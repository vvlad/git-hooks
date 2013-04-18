#!/usr/bin/env ruby

require 'pivotal-tracker'
require 'highline/import'



api_key = `git config --get pivotal.api-key`.strip
project_id = `git config --get pivotal.project-id`.strip

puts "git config --global --set pivotal.api-key <your api key>" if api_key.empty?
puts "git config --local --set pivotal.project-id <project id>" if project_id.empty?

PivotalTracker::Client.token = api_key
project = PivotalTracker::Project.find( project_id )

msg = IO.read(ARGV.first).scan(/\[(\w+)\s{0,}?#(\d+)\s{0,}?\]/).map do |match|
  stroy_id = $2
  if stroy = project.stories.find(stroy_id)
    "[#{$1} ##{stroy_id}] #{stroy.name}"
  else
    puts "Stroy with id=#{stroy_id} not found"
    exit 1
  end
end.join("\n")

open(ARGV.first,"w") do |file|
  file.puts msg
end

