module.exports = (robot) ->
  github = require("githubot")(robot)

  robot.respond /open pull from ([-_\.0-9a-zA-Z]+)\/([-_\.a-zA-z0-9\/]+)\/([-_\.a-zA-z0-9\/]+)(?: into ([-_\.a-zA-z0-9\/]+))?(?: "(.*)")?$/i, (msg) ->
    default_body = 'This is a body'
    base = msg.match[4] || 'master'

    data = {
      title: "PR to merge #{msg.match[3]} into #{base}",
      head: msg.match[3],
      base: base,
      body: msg.match[5] || default_body
    }

    github.handleErrors (response) ->
      switch response.statusCode
        when 404
          msg.send 'Sorry mate, this is not a valid repo that I have access to.'
        when 422
          msg.send "Yo mate, the pull request has already been created or the branch does not exist."
        else
          msg.send 'Sorry mate, something is wrong with your request.'

    github.post "repos/#{msg.match[1]}/#{msg.match[2]}/pulls", data, (pr) ->
      msg.send "Pull request created for #{msg.match[3]}. #{pr.html_url}"
