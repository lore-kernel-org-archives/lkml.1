Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0BOGyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 01:54:24 -0500
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:47833 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab0BOGyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 01:54:22 -0500
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Feb 2010 01:54:22 EST
Message-ID: <4B78EF9C.6040801@shikadi.net>
Date: Mon, 15 Feb 2010 16:54:20 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.23) Gecko/20091130 Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: UML error - apps killed 50% of the time
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

 From my other message I am trying to get a UML kernel running again after an 
OS upgrade, but I am unable to get it working again (on the original machine 
this time, everything is 32-bit.)

When I boot the kernel normally I get tons of error messages, but if I boot it 
with "init=/bin/bash" I can get a command prompt up.  Unfortunately most of 
the time my apps break:

$ ls
bin  boot  dev  etc  home  lib  lost+found  mnt  opt  proc  root  sbin  sys 
tmp  usr  var
$ ls
Killed
$ ls
bin  boot  dev  etc  home  lib  lost+found  mnt  opt  proc  root  sbin  sys 
tmp  usr  var
$ ls
Killed
$ ls
Killed
$ ls
bin  boot  dev  etc  home  lib  lost+found  mnt  opt  proc  root  sbin  sys 
tmp  usr  var

What's going on?  My host dmesg says things like this:

vmlinux[6300] general protection eip:b7ea5124 esp:1785bdfc error:0

Why doesn't UML work any more?  It's running the same filesystem and apps as 
before.  Any help would be much appreciated, I've wasted hours on this now :-(

Thanks,
Adam.

(please CC)
