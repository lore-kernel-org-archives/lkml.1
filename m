Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbYAHRtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbYAHRtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbYAHRsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:48:53 -0500
Received: from main.gmane.org ([80.91.229.2]:46869 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbYAHRsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:48:53 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tuomo Valkonen <tuomov@iki.fi>
Subject: Re: The ext3 way of journalling
Date: Tue, 8 Jan 2008 17:48:43 +0000 (UTC)
Message-ID: <slrnfo7drr.c37.tuomov@jolt.modeemi.cs.tut.fi>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <Pine.LNX.4.64.0801081725480.3032@fbirervta.pbzchgretzou.qr> <slrnfo7aiq.6m2.tuomov@jolt.modeemi.cs.tut.fi> <Pine.LNX.4.64.0801081801300.3032@fbirervta.pbzchgretzou.qr>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: jolt.modeemi.cs.tut.fi
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-01-08, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> Roll your own.

Nah, too much work, and I want all distros to perish.

> "Power users" may still 
> use the index= option of sound card modules and wire it up in 
> /etc/modprobe.d if they prefer.

Another very cryptic directory whose contents say nothing to me.
Configuration files should be self-documenting and editable,
instead having to be created based on long documentation.
The simple /etc/modules -- which at least Debian's stock kernels
do not use -- qualifies, but few other files these days do.

> You can guess my answer: udev will fix it. 

And break everything else, such as my symlinks, permissions, etc. 
I'm not going to learn its cryptic special-case config files for 
such trivial tasks as creating a fucking symlink or change the 
permissions of a file, for which exist general purpose methods:
chmod, chown, ln -s.

> Well what do you expect of it? The kernel does not keep USB port <-> 
> SCSI device mappings. Neither USB device <-> SCSI device mapping, 
> because not all USB ports or USB devices are mass-storage devices.
> It just is not the kernel's job.

Mapping everything to scsi nodes is brain damaged. The old hda, hdb,
etc. mappings had somewhat clear correspondence between to physical
evice addresses, and were easy to use without such complicated crap
as udev. Of course, I'd prefer just device unique IDs being used,
where possible... but I'm not going to suffer udev for that.

> Mine plays very well.

I was not talking of encrypted disks but cryptic udev config files,
that the distros are going to break on every upgrade.

> May I remind you that the kernel also "loses" all your network interface 
> configuration, routes, firewalling rules and all sysctl settings at 
> boot (sic: reboot & powerdown).

But traditional /dev does not lose permissions and symlinks. udev 
tmpfs shadow brain damage does. You have to illogically and
inconveniently edit udev's cryptic config files instead, and yet
it in no way stops /dev from being modified.

> Distros have to decide whether to
>
> - not autoload a zillion of modules, potentially generating lots of 
> crying "idiot" users
>
> - autoload a zillion of modules, potentially firing you up.

And they most of them cater for idiot users, and the rest for
develors what want to do it all from scratch. Mere power users
who want to tune the system to their needs, but easily and without
WIMPshit (through _simple_ self-documenting configuration files),
are forgotten these days.

> Nonsense. The kernel notices udev about all available hardware and udev 
> will load modules. It has nothing to do with initrd, in fact, this very 
> step of loading a gazillion of modules is done after initrd has passed 
> control on to /sbin/init. At least, in opensuse.

I've never seen a system that would do so. And I won't use udev.

-- 
Tuomo

