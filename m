Return-Path: <linux-kernel-owner+w=401wt.eu-S1751572AbXBCXt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbXBCXt7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 18:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbXBCXt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 18:49:59 -0500
Received: from styx.suse.cz ([82.119.242.94]:60766 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751572AbXBCXt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 18:49:58 -0500
Date: Sun, 4 Feb 2007 00:50:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Elimar Riesebieter <riesebie@lxtec.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20-rc7: hid on PPC
In-Reply-To: <20070202205151.GA3212@aragorn.home.lxtec.de>
Message-ID: <Pine.LNX.4.64.0702040046280.22958@jikos.suse.cz>
References: <20070202205151.GA3212@aragorn.home.lxtec.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Feb 2007, Elimar Riesebieter wrote:

> it would be great, if we can choose pb_fnmode while configure the 
> kernel. I have a PowerBook5,6 but want fkeysfirst. So I have to # echo 2 
> >| /sys/module/hid/parameters/pb_fnmode by hand after each boot. The 
> module-parm pb_fnmode doesn't work either in /etc/modules nor in a 
> modprobe instruction while boot. An modprobe -r usb-hid hid; sleep 2; 
> modprobe hid pb_fnmode=2; modprobe usb-hid works on a fresh booted 
> machine. Else module-parm isn't available with a built-in hid, though.

Hi Elimar,

sorry, but I don't seem to understand your problem. There are two 
situations - either you have hid bultin in kernel, or compiled as a 
module. In the first case, you simply modify the kernel boot commandline 
to contain a string 

	hid.pb_fnmode=2 

and that's it. In the latter case, you add something like 

	options hid     pb_fnmode=2

into the /etc/modprobe.conf file (or you can use any distro-specific way 
to pass parameters to modules, such as /etc/modprobe.d). This is standard 
way to do things, and it works also with hid.

I don't think there is a need to have this as a separate kernel 
configuration option.

Thanks,

-- 
Jiri Kosina
SUSE Labs
