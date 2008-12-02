Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbYLBPaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbYLBPaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbYLBPaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:30:19 -0500
Received: from mk-outboundfilter-6-a-2.mail.uk.tiscali.com ([212.74.114.16]:27585
	"EHLO mk-outboundfilter-6-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550AbYLBPaR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:30:17 -0500
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2008 10:30:17 EST
X-Trace: 57846566/mk-outboundfilter-6.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAPXgNEnDlSwG/2dsb2JhbACBbcU6AQKLcoIAAQN7
X-IronPort-AV: E=Sophos;i="4.33,702,1220223600"; 
   d="scan'208";a="57846566"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Alejandro Riveira =?iso-8859-1?q?Fern=E1ndez?= 
	<ariveira@gmail.com>
Subject: Re: Linux 2.6.28-rc7
Date: Tue, 2 Dec 2008 15:20:25 +0000
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc6-damocles; KDE/4.1.3; x86_64; ; )
Cc: pazke <pazke@ports.donpac.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0812012004370.3256@nehalem.linux-foundation.org> <20081202131158.GA15186@ports.donpac.ru> <20081202154815.48379b99@varda>
In-Reply-To: <20081202154815.48379b99@varda>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812021520.25856.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 December 2008 14:48:15 Alejandro Riveira Fernández wrote:
> El Tue, 2 Dec 2008 16:11:58 +0300
>
> pazke <pazke@ports.donpac.ru> escribió:
> > On 337, 12 02, 2008 at 01:14:42PM +0100, Alejandro Riveira Fern??ndez 
wrote:
> > > El Mon, 1 Dec 2008 20:11:55 -0800 (PST)
> > >
> > > Linus Torvalds <torvalds@linux-foundation.org> escribi??:
> > > > I was gone for a week, and it wasn't quite as quiet as I was hoping
> > > > for, but there's a new -rc out there now with the merges of the
> > > > fallout.
> > > >
> > > > Almost all of it is various driver fixes, at least if you ignore the
> > > > (bulky) powerpc defconfig updates. The bulk being ACPI, DRM, input
> > > > and V4L, but with a smattering of usb, networking, infiniband and
> > > > firewire.
> > > >
> > > > Oh, and a number of section warning fixes.
> > > >
> > > > The shortlog is about as informative as it gets - it's all about a
> > > > lot of small details.
> > > >
> > > > 		Linus
> > >
> > >  Just tried it on my Ubuntu 8.10 install.
> > >  Booted fine and the distro got to its safe graphics mode because i'm
> > >  evil and use the nvidia kernel module. i switch to VT1 and the fun
> > >  begins something weird happens with the terminal...
> > >  I can not see the login: not the password: promts
> > >  I log in blindly
> > >  When i type a command nothing appears on screen i have to hit enter
> > > twice one make the command appear the second actually executes
> > >  After that i have to hit enter once more to get the shell promt again
> > >  Also I couldn't use sudo the password promt did not get my password
> > >
> > >  All of this happens without the nvidia module loaded (not even
> > > compiled)
> >
> > Realy ?
> >
> > > [  101.744347] nvidia: module license 'NVIDIA' taints kernel.
> > > [  102.003828] nvidia 0000:01:00.0: PCI INT A -> GSI 25 (level, low) ->
> > > IRQ 25 [  102.003838] nvidia 0000:01:00.0: setting latency timer to 64
> > > [  102.004747] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  180.06 
> > > Sat Nov  8 17:50:38 PST 2008
> >
> > 		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > Where do these messages come from then ?
>
>  I took the sanpshot of the dmesg after loading the module if my word is
> not enough i can reboot with the module disabled but i do not see the
> point... The truth is that the bug prevented me from loading/installing the
> nvidia module becouse i could not use sudo. Only when i rebooted into
> single mode where the problems went away i could build and install the
> module...

One thing I would point out is that your distro kernel (presumably 2.6.27 or 
older) would probably have had the NVIDIA module to hand and would not drop 
into safe mode, right? In this case, VT switching behaviour may be entirely 
different.

Could you please find out what framebuffer driver your distro is loading 
(probably nvidiafb, I'd guess) before starting X, and what Xorg driver Ubuntu 
use in this "safe graphics mode" (nv, vesa)? Also, could you try removing the 
nvidia module in the older kernel and confirm that the same VT corruption does 
not occur, so Rafael can identify this as a regression?

(Maybe things have changed over the years, but my understanding was that for 
the majority of Xorg drivers, mode setting was still done by the Xorg driver, 
not the kernel, and the X server is responsible for restoring the VT 
correctly, not the kernel's framebuffer driver. So this may possibly not be a 
kernel bug at all.)

-- 
Cheers,
Alistair.
