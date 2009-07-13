Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbZGMU3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbZGMU3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 16:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZGMU3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 16:29:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53658 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbZGMU3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 16:29:11 -0400
Date: Mon, 13 Jul 2009 22:27:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Arve Hj??nnev??g <arve@google.com>, Iliyan Malchev <malchev@google.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC Dream camera support for staging
Message-ID: <20090713202720.GD2569@elf.ucw.cz>
References: <20090629114339.GA25552@elf.ucw.cz> <20090629121023.GD28046@google.com> <20090630102457.GA25802@elf.ucw.cz> <a55d774e0906300338l7743d566k5b463eed3efd1ea1@mail.gmail.com> <20090709101315.GF10937@elf.ucw.cz> <a55d774e0907090406u5e91b5c9r2303b098d0e44988@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0907090406u5e91b5c9r2303b098d0e44988@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-07-09 04:06:35, Brian Swetland wrote:
> (arve -- see below about matrix driver)

Arve, can you help?

> On Thu, Jul 9, 2009 at 3:13 AM, Pavel Machek<pavel@ucw.cz> wrote:
> >>
> >> The NAND and USB support is much more contained.
> >
> > Well.. NAND scares me a bit -- and I'm happy with SD card for now.
> 
> Well, you actually can't overwrite the bootloader with the way the
> NAND partitions are protected and made visible to the arm11, and the
> bootloader can reflash the boot/recovery/system/user partitions via
> usb using fastboot.

Ok, good to know.

> > USB support seems complex because it duplicates USB gadget framework :-(.
> 
> Actually we have both.  We did the function framework before the
> gadget framework had multifunction/composite support, but we're now
> moving away from that since the necessary functionality is in gadget
> now.  The latest 2.6.29 tree on our side has a gadget driver for the
> USB client controller and an "android" gadget that handles the adb
> protocol function and ums function.

ums == mass storage? What is adb? ... aha, adb is the debugger.

> > gpio_matrix: I thought in-tree zaurus keypad driver has recently
> > became generic enough to almost replace this?
> 
> Looping Arve in.  I think he had issues with lack of phantom key
> detection, etc with that.

Arve, can you help?

> > +config TOUCHSCREEN_ELAN_I2C_8232
> > /
> > +config TOUCHSCREEN_SYNAPTICS_I2C_RMI
> >
> > ...which one is it on Dream?
> 
> Both, possibly.  HTC used elan as a second source, so some devices
> will use elan, some use synaptics.

Is there easy way to tell the machines apart? Are there any hardware
differences (besides case color and touchscreen chip)?

> Dream is definitely not the last Android device with a keyboard.

Cool.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
