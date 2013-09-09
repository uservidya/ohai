#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2008 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

Ohai.plugin do
  provides "kernel"
  provides "kernel/name", "kernel/release", "kernel/version", "kernel/machine", "kernel/modules"

  depends "languages/ruby"

  collect_data do
    kernel Mash.new
    case languages[:ruby][:host_os]
    when /mswin|mingw32|windows/
      require_plugin "windows::kernel"
      require_plugin "windows::kernel_devices"
    else
      [["uname -s", :name], ["uname -r", :release],
       ["uname -v", :version], ["uname -m", :machine]].each do |command, node|
        so = shell_out(command)
        kernel[node] = so.stdout.split($/)[0]
      end
      kernel[:modules] = Mash.new
    end
  end
end
