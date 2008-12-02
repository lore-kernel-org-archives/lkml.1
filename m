Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbYLBPvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbYLBPvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbYLBPux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:50:53 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:17181 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYLBPuv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:50:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=EUE3jgazSUAsXZt88jykih4gsxCn3s1P29+iNkA12fGu/d8UPR94kiCm4Fl6ucNEbP
         ffnvCdQb/3BdPMEhqDBC4vEqk/N8tBuShkG88uw8QPcZLcEitFu5QdixcmO9cMEjjpwQ
         VK/w5a5KqizPr/xe669dILivSUMJOA1MZ/w9k=
Date: Tue, 2 Dec 2008 16:50:47 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: pazke <pazke@ports.donpac.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc7
Message-ID: <20081202165047.3d09bf43@varda>
In-Reply-To: <200812021520.25856.alistair@devzero.co.uk>
References: <alpine.LFD.2.00.0812012004370.3256@nehalem.linux-foundation.org>
	<20081202131158.GA15186@ports.donpac.ru>
	<20081202154815.48379b99@varda>
	<200812021520.25856.alistair@devzero.co.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 2 Dec 2008 15:20:25 +0000
Alistair John Strachan <alistair@devzero.co.uk> escribió:

> On Tuesday 02 December 2008 14:48:15 Alejandro Riveira Fernández wrote:
> > El Tue, 2 Dec 2008 16:11:58 +0300
> >
> > pazke <pazke@ports.donpac.ru> escribió:
> > > On 337, 12 02, 2008 at 01:14:42PM +0100, Alejandro Riveira Fern??ndez 
> wrote:
> > > > El Mon, 1 Dec 2008 20:11:55 -0800 (PST)
> > > >
> > > > Linus Torvalds <torvalds@linux-foundation.org> escribi??:
> > > > > I was gone for a week, and it wasn't quite as quiet as I was hoping
> > > > > for, but there's a new -rc out there now with the merges of the
> > > > > fallout.
> > > > >
> > > > > Almost all of it is various driver fixes, at least if you ignore the
> > > > > (bulky) powerpc defconfig updates. The bulk being ACPI, DRM, input
> > > > > and V4L, but with a smattering of usb, networking, infiniband and
> > > > > firewire.
> > > > >
> > > > > Oh, and a number of section warning fixes.
> > > > >
> > > > > The shortlog is about as informative as it gets - it's all about a
> > > > > lot of small details.
> > > > >
> > > > > 		Linus
> > > >
> > > >  Just tried it on my Ubuntu 8.10 install.
> > > >  Booted fine and the distro got to its safe graphics mode because i'm
> > > >  evil and use the nvidia kernel module. i switch to VT1 and the fun
> > > >  begins something weird happens with the terminal...
> > > >  I can not see the login: not the password: promts
> > > >  I log in blindly
> > > >  When i type a command nothing appears on screen i have to hit enter
> > > > twice one make the command appear the second actually executes
> > > >  After that i have to hit enter once more to get the shell promt again
> > > >  Also I couldn't use sudo the password promt did not get my password
> > > >
> > > >  All of this happens without the nvidia module loaded (not even
> > > > compiled)
> > >
> > > Realy ?
> > >
> > > > [  101.744347] nvidia: module license 'NVIDIA' taints kernel.
> > > > [  102.003828] nvidia 0000:01:00.0: PCI INT A -> GSI 25 (level, low) ->
> > > > IRQ 25 [  102.003838] nvidia 0000:01:00.0: setting latency timer to 64
> > > > [  102.004747] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  180.06 
> > > > Sat Nov  8 17:50:38 PST 2008
> > >
> > > 		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > Where do these messages come from then ?
> >
> >  I took the sanpshot of the dmesg after loading the module if my word is
> > not enough i can reboot with the module disabled but i do not see the
> > point... The truth is that the bug prevented me from loading/installing the
> > nvidia module becouse i could not use sudo. Only when i rebooted into
> > single mode where the problems went away i could build and install the
> > module...
> 
> One thing I would point out is that your distro kernel (presumably 2.6.27 or 
> older) would probably have had the NVIDIA module to hand and would not drop 
> into safe mode, right? In this case, VT switching behaviour may be entirely 
> different.

 i do not have the distro provided module installed so it will indeed drop
to safe graphic mode if i booted with it... truth is i allways use vanilla
kernels and i've never booted into the distro provided kernel since i upgraded
from 8.04 to 8.10

> 
> Could you please find out what framebuffer driver your distro is loading 
> (probably nvidiafb, I'd guess) before starting X, and what Xorg driver Ubuntu 
> use in this "safe graphics mode" (nv, vesa)? 

 what would be the best way to find this out? 

> Also, could you try removing the 
> nvidia module in the older kernel and confirm that the same VT corruption does 
> not occur, so Rafael can identify this as a regression?

 it is indeed a regression if the same problem have would ocurred when i tried
the -rc6 kernel i would have noticed the same behavior when trying to install
the nvidia module.
 Also 2.6.27.x estable kernels do not exhibit this behavior

> 
> (Maybe things have changed over the years, but my understanding was that for 
> the majority of Xorg drivers, mode setting was still done by the Xorg driver, 
> not the kernel, and the X server is responsible for restoring the VT 
> correctly, not the kernel's framebuffer driver. So this may possibly not be a 
> kernel bug at all.)

 Given that this is easily reproducible i may try to biect rc6 <--> rc7...
it may take a few days though

> 

Thanks for your time
