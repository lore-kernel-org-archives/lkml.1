Return-Path: <linux-kernel-owner+w=401wt.eu-S1762183AbXK2Lxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762183AbXK2Lxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 06:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbXK2Lx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 06:53:27 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:40001 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbXK2Lx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 06:53:26 -0500
Message-ID: <1618816c0711290353h3c0e4192we5909725d1aff3e9@mail.gmail.com>
Date: Thu, 29 Nov 2007 04:53:25 -0700
From: "Raymano Garibaldi" <raymano@faunos.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] [BUG] USB_PERSIST
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Denys Vlasenko" <vda.linux@googlemail.com>,
       "Kernel development list" <linux-kernel@vger.kernel.org>,
       "USB development list" <linux-usb-devel@lists.sourceforge.net>,
       kirk@faunos.com
In-Reply-To: <Pine.LNX.4.44L0.0711281711210.3641-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1618816c0711272202ydd8f1aeib98672d91356368a@mail.gmail.com>
	 <Pine.LNX.4.44L0.0711281711210.3641-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The feature does work as long as the device remains plugged in and
that is what I have said in my previous postings too. What I'm saying
that should work and worked under 2.6.21 and is not working currently
is the ability to unplug and plug back in the device while the
computer is suspended before resuming without losing the mount.

On 11/28/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 27 Nov 2007, Raymano Garibaldi wrote:
>
> > Hi Alan,
> >
> > Here's what I got after compiling kernel with CONFIG_USB_PERSIST and
> > CONFIG_USB_DEBUG both enabled. The attached files are:
> >
> > config - shows the .config file used when compiling kernel 2.6.23.9
> >
> > sysandmount.txt - shows mounts and the state of persist for all usb
> > devices right before suspending.
> >
> > dmesg_attached.txt - dmesg right after resuming when the USB device
> > remained attached while machine was suspend
> >
> > dmesg_detachedandreattached.txt - dmesg right after resuming when the
> > USB device was detached while suspended and then reattached before
> > resuming.
>
> This all looks okay.  Earlier you wrote:
>
> > I have tried this. Simply turning off CONFIG_USB_PERSIST doesn't work.
> > In this case the USB drive file system is unmounted on resume, even if
> > the drive remained plugged in during suspend.
>
> But the logs you just posted show that the filesystem _does_ remain
> mounted after resume, provided you don't unplug the drive.  At least
> that's what it looked like -- it was hard to tell for sure because each
> logfile contained multiple suspend/resume cycles with varying outcomes.
>
> Alan Stern
>
>
