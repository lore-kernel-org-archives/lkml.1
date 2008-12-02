Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYLBOsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYLBOsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 09:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbYLBOsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 09:48:22 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:51132 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbYLBOsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 09:48:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Ooge8zg/I/HsNqRXvfTCDiyd7X8sHJynXlsDT5Iz5gCbes6DM+hCc4JBne3U6+CNhx
         +JMSCoobeSc5T5My/qIDElVgksc707pQxz1W9/2h5Fi7xvLOdRBb+F0fOgyCuVChR0k/
         VXxY4uMXiOny7LEx80KBabXD35wX5w+WdbQO8=
Date: Tue, 2 Dec 2008 15:48:15 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: pazke <pazke@ports.donpac.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc7
Message-ID: <20081202154815.48379b99@varda>
In-Reply-To: <20081202131158.GA15186@ports.donpac.ru>
References: <alpine.LFD.2.00.0812012004370.3256@nehalem.linux-foundation.org>
	<20081202131442.42e7df48@varda>
	<20081202131158.GA15186@ports.donpac.ru>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 2 Dec 2008 16:11:58 +0300
pazke <pazke@ports.donpac.ru> escribió:

> On 337, 12 02, 2008 at 01:14:42PM +0100, Alejandro Riveira Fern??ndez wrote:
> > El Mon, 1 Dec 2008 20:11:55 -0800 (PST)
> > Linus Torvalds <torvalds@linux-foundation.org> escribi??:
> > 
> > > 
> > > I was gone for a week, and it wasn't quite as quiet as I was hoping for, 
> > > but there's a new -rc out there now with the merges of the fallout.
> > > 
> > > Almost all of it is various driver fixes, at least if you ignore the 
> > > (bulky) powerpc defconfig updates. The bulk being ACPI, DRM, input and 
> > > V4L, but with a smattering of usb, networking, infiniband and firewire.
> > > 
> > > Oh, and a number of section warning fixes.
> > > 
> > > The shortlog is about as informative as it gets - it's all about a lot of 
> > > small details.
> > > 
> > > 		Linus
> > > 
> > 
> >  Just tried it on my Ubuntu 8.10 install.
> >  Booted fine and the distro got to its safe graphics mode because i'm
> >  evil and use the nvidia kernel module. i switch to VT1 and the fun
> >  begins something weird happens with the terminal...
> >  I can not see the login: not the password: promts 
> >  I log in blindly
> >  When i type a command nothing appears on screen i have to hit enter twice
> >  one make the command appear the second actually executes
> >  After that i have to hit enter once more to get the shell promt again
> >  Also I couldn't use sudo the password promt did not get my password
> >  
> >  All of this happens without the nvidia module loaded (not even compiled) 
> 
> Realy ?
> 
> > [  101.744347] nvidia: module license 'NVIDIA' taints kernel.
> > [  102.003828] nvidia 0000:01:00.0: PCI INT A -> GSI 25 (level, low) -> IRQ 25
> > [  102.003838] nvidia 0000:01:00.0: setting latency timer to 64
> > [  102.004747] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  180.06  Sat Nov  8 17:50:38 PST 2008
> 		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Where do these messages come from then ?

 I took the sanpshot of the dmesg after loading the module if my word is not
enough i can reboot with the module disabled but i do not see the point...
The truth is that the bug prevented me from loading/installing the nvidia
module becouse i could not use sudo. Only when i rebooted into single mode
where the problems went away i could build and install the module...
