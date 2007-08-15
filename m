Return-Path: <linux-kernel-owner+w=401wt.eu-S1765429AbXHOPZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765429AbXHOPZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 11:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761202AbXHOPYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 11:24:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56978 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760846AbXHOPYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 11:24:51 -0400
Date: Wed, 15 Aug 2007 11:24:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florin Iucha <florin@iucha.net>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Tejun Heo <htejun@gmail.com>, Greg KH <gregkh@suse.de>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with linux
 v2.6.23-rc3-50-g28e8351
In-Reply-To: <20070815145005.GB7124@iucha.net>
Message-ID: <Pine.LNX.4.44L0.0708151120410.3895-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007, Florin Iucha wrote:

> On Wed, Aug 15, 2007 at 10:38:54AM -0400, Alan Stern wrote:
> > This patch will get rid of the annoying error messages.  It won't do 
> > anything about your keyboard's tendency to spontaneously stop working, 
> > alas.
> 
> My keyboard works fine for days, with kernels up to and including
> 2.6.23-rc2 . I have booted into 2.6.23-rc3-$whatever this morning, and
> after 10-15 minutes the keyboard stopped working.  The mice which were
> plugged in the keyboard's built-in hub were fine though.
> 
> The first time it happened, I removed the keyboard and got the oops
> that started this thread.

It wasn't an oops, just a warning.

>  The second time, I just logged-in remotely
> and rebooted, and the reboot process stopped at "KILLING all
> processes" step.  I simply reset the box and rebooted into 2.6.23-rc2
> and it is fine since (over an hour ago).

To track this down, you might try building 2.6.23-rc3 with 
CONFIG_USB_DEBUG enabled.  Then retrieve the dmesg log after the 
keyboard stops working and post it.  You probably ought to CC: the 
maintainer of the HID core layer as well (and you can trim the existing 
CC: list).

Alan Stern

