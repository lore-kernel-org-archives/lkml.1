Return-Path: <linux-kernel-owner+w=401wt.eu-S933154AbZJFUL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbZJFUL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933084AbZJFULZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:11:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39885 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932272AbZJFULY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:11:24 -0400
Date: Tue, 6 Oct 2009 16:10:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Contreras <felipe.contreras@gmail.com>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: Annoying problems with lacie external hd (JMicron 0x2339?)
In-Reply-To: <94a0d4530910061157q7b682750r3279bca4716cd532@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0910061604160.3002-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009, Felipe Contreras wrote:

> On Sun, Oct 4, 2009 at 12:26 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Sat, 3 Oct 2009, Felipe Contreras wrote:
> >
> >> Hi,
> >>
> >> This is with 2.6.31.1.
> >>
> >> I'm having a lot of problems with a lacie external hd[1]. It seems the
> >> actual disk is a seagate ST375064, and the bridge is a JMicron 2339.
> >>
> >> In normal usage what I see is that if I don't use the disk after a
> >> while hear a loud click (as if something got stuck) and then I cannot
> >> use it any more; I have to turn it off and on again.
> >
> > This sounds very much like a hardware problem, either in the drive or
> > in the bridge chip.  There's no direct way to tell which; you would
> > have to try attaching the drive to a different chip or the chip to a
> > different drive.
> 
> I'm not sure I can do that. There doesn't seem to be any way to open
> the device and I don't have a way to test neither the disk, nor the
> bridge. I would like to leave that as last option.

Then it doesn't really matter whether the problem is in the drive or in
the chip, since separating them is impractical.

> > The two places where your listings showed the Serial number (the kernel
> > log and the /sys/kernel/debug/usb/devices file) have different values,
> > suggesting that the chip is at fault.  But this isn't definitive.
> 
> The first reported serial number seems to be correct, but the second
> one (after the click) isn't.
> 
> Anyway, what about all the errors before the loud click? Couldn't it
> be that the driver is causing the device to malfunction?

I doubt that very much.  And besides, if the device were designed
properly then it wouldn't malfunction, no matter what the driver did.

>  At least the
> patch seems to decrease the number of reported bad blocks. Once
> applying the patch the first block of bad blocks is always the same,
> but the second is always different, then the click happens.
> 
> I'm attaching the full log.

A usbmon trace would contain more information.  We could see the exact
sequence of commands and error codes.  I'm not sure it would help solve
anything, though.

You could try plugging the device into a different computer and see if 
it behaves the same way.  If it does, your best course might be to 
exchange it for something that works better.

Alan Stern

