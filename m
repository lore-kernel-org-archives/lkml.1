Return-Path: <linux-kernel-owner+w=401wt.eu-S1759295AbXK1WPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295AbXK1WPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbXK1WOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:14:52 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41988 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754391AbXK1WOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:14:52 -0500
Date: Wed, 28 Nov 2007 17:14:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Raymano Garibaldi <raymano@faunos.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [BUG] USB_PERSIST
In-Reply-To: <1618816c0711272202ydd8f1aeib98672d91356368a@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0711281711210.3641-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007, Raymano Garibaldi wrote:

> Hi Alan,
> 
> Here's what I got after compiling kernel with CONFIG_USB_PERSIST and
> CONFIG_USB_DEBUG both enabled. The attached files are:
> 
> config - shows the .config file used when compiling kernel 2.6.23.9
> 
> sysandmount.txt - shows mounts and the state of persist for all usb
> devices right before suspending.
> 
> dmesg_attached.txt - dmesg right after resuming when the USB device
> remained attached while machine was suspend
> 
> dmesg_detachedandreattached.txt - dmesg right after resuming when the
> USB device was detached while suspended and then reattached before
> resuming.

This all looks okay.  Earlier you wrote:

> I have tried this. Simply turning off CONFIG_USB_PERSIST doesn't work.
> In this case the USB drive file system is unmounted on resume, even if
> the drive remained plugged in during suspend.

But the logs you just posted show that the filesystem _does_ remain 
mounted after resume, provided you don't unplug the drive.  At least 
that's what it looked like -- it was hard to tell for sure because each 
logfile contained multiple suspend/resume cycles with varying outcomes.

Alan Stern

