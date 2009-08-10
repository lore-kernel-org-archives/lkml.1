Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbZHJOmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbZHJOmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZHJOmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:42:25 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:51726 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbZHJOmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:42:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19072.12751.294751.725334@stoffel.org>
Date: Mon, 10 Aug 2009 10:42:23 -0400
From: "John Stoffel" <john@stoffel.org>
To: devzero@web.de
Cc: Martin Rogge <marogge@onlinehome.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.30.1-4 kernels freezes dual pentium-3 system
In-Reply-To: <859079895@web.de>
References: <859079895@web.de>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "devzero" == devzero  <devzero@web.de> writes:

>> Box  works  works fine and very stable under 2.6.29.5 kernel, although
>> it is angry of buggy MP table (see app. #2 below). But sometimes, this
>> kernel  correctly  reboots  the  system  at all, but this happens very
>> rarely.  In  most cases, nobody detects the box was rebooted. And this
>> is satisfactory for me.

devzero> so, what is it - stable or not stable ?

In my case, it's been stable under 2.6.29 (though with a Raid crash
after 30+ days of uptime...).  Under anything newer, it hasn't been
stable, though I admit I haven't tried 2.6.29.x yet, though maybe
2.6.29.1 was ok.  Not sure. 

devzero> if sometimes "this kernel correctly reboots the system", do
devzero> you mean that happens spontaneously, i.e. without being
devzero> actively triggered ?

Kernel never reboots, the system locks up hard and *nothing* gets it
back beyond the reset button.  SysRq is total hosed, doesn't do
anything. 

devzero> i think it would be more interesting if there is anything in
devzero> dmesg on such lockup.  if not, maybe you can hook up a serial
devzero> console or netconsole and trigger sysrq when you have another
devzero> lockup.

There's notthing in dmesg, nothing on the screen (it's a server and
not usually connected to a screen) and my other main machine is the
NFS client of this box, so it's kinda painful to monitor.  

I need to try rigging up a completely standalone system to do both
netconsole and serial port console to see if I catch anything.  

John
