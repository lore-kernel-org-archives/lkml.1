Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbYLBToq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbYLBToq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 14:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbYLBToh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 14:44:37 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:64195 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbYLBToh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 14:44:37 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=6Mvy9RbFAAAA:8 a=_yJynC5uhYle_ZE7ZdYA:9 a=j_m9tDPm5n--8F6TFLoA:7 a=whJQ8g-gUNUMHjmm5TGR8cRAbaoA:4
Message-ID: <49358FC7.8070106@gnat.ca>
Date: Tue, 02 Dec 2008 12:43:03 -0700
From: "Nathanael D. Noblet" <nathanael@gnat.ca>
Organization: Gnat Solutions, Inc
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PS/2 Issues
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
    Total noob here, but I'm having issues with ps2 keyboard/mouse 
suddenly no longer responding. I use fedora and this has happened for 
the last three versions however f10 seems to be even more often. Let me 
describe the situation and what I've done to try to find the cause.


    Periodically my system 'hangs' in that it no longer accepts input 
from either mouse or keyboard plugged into the PS2 ports. Any music / 
video playing continues. All apps continue. I can ssh into the box and 
top reveals no huge spike in load or anything out of the ordinary. I am 
using an ATI card with the OSS video drivers, but even if I go to init 3 
I don't regain input response. I was told to see if perhaps any of the 
events threads were blocked or otherwise not running. So via ssh I 
prompted a sysrq-t to the logs. This produced this output 
http://hashbin.com/vPF . As you can see the output is garbled. I've done 
it a few times and the location of the garbled output is different each 
time. I've run this system under memtest for hours and hours without any 
issue.

   Additional information. If I plug in a usb mouse, it works fine and I 
can reboot the machine cleanly. The problem is easily triggered by 
running a bittorrent client with many torrents. At least it tends to 
lock up soon after that. I've also had lockups sooner when sharing via 
nfs. Even without those programs running I still have lockups 
periodically, however those programs being active shorten the time 
between lockups. If I don't run them sometimes I can last a week, 
sometimes an hour before needing to reboot. I've talked to people on the 
#fedora-kernel room, but no-one there either had ideas or responded.

   I'm willing to do the work to figure this out, but I have yet to 
really debug a kernel issue. there is no kernel oops being logged, no 
errors nothing out of the ordinary, but all of a sudden ps2 input is 
gone. I'm about to purchase a PS2->usb adapter to run my keyboard and 
mouse through that to see if they are affected by the issue.

   Ideas pointers or methods to provide more information would be 
appreciated.

-- 
Nathanael d. Noblet
