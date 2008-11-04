Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbYKDQRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbYKDQRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbYKDQRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:17:12 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:55476 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbYKDQRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:17:11 -0500
Date: Tue, 4 Nov 2008 17:17:08 +0100
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mattia Dongili <malattia@linux.it>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usb device not showing up
Message-ID: <20081104161708.GA32570@gamma.logic.tuwien.ac.at>
References: <20081104093710.GC15846@gamma.logic.tuwien.ac.at> <Pine.LNX.4.44L0.0811041015010.2642-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0811041015010.2642-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 04 Nov 2008, Alan Stern wrote:
> > - First booting Vista, then RE-booting (not turning it off in the
> >   meantime) into linux gives me that device and everything works.
> 
> By "it", did you mean the laptop or the modem?

I meant: 
- first booting vista, then re-booting ... the device shows up (and is
  functional)

- booting from off state the device does not show up and cannot be
  switched on using /sys/devices/platform/sony-laptop/wwanpower
  (although the behaviour that it can be switched on using the above
  sysfs file is documented)

> No.  I'm interested in seeing the usbmon output for when the modem is
> first detected by the USB subsystem.  During a normal boot this will 
> happen before you can start usbmon.
> 
> If you can't boot with the modem off, then try this instead: Unload 
> ehci-hcd, uhci-hcd, and ohci-hcd, then start up usbmon (copy the 0u 
> file) and reload whichever driver the modem attaches to.

Ok, I will recompile my kernel with USB as modules and do the above. Is
there a way to tell the kernel not to load any device drivers/modules
(probably overriding modprobe in some way)?

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
OUNDLE (vb.)
To walk along leaning sideways, with one arm hanging limp and dragging
one leg behind the other. Most commonly used by actors in amateur
production of Richard III, or by people carrying a heavy suitcase in
one hand.
			--- Douglas Adams, The Meaning of Liff
