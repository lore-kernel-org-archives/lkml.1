Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbZGYFWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbZGYFWD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 01:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZGYFWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 01:22:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:41329 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbZGYFWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 01:22:02 -0400
Date: Fri, 24 Jul 2009 22:14:34 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk
Subject: Re: [Security] Should open TTY device files pin minor numbers?
Message-ID: <20090725051434.GD19432@kroah.com>
References: <Pine.LNX.4.44L0.0907231421390.3509-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0907231421390.3509-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 02:38:01PM -0400, Alan Stern wrote:
> Recent work in the TTY core and in usb-serial has caused a change 
> in behavior between 2.6.30 and 2.6.31-rc.  Namely, if a USB serial 
> device is unplugged while a process holds the device file open, the 
> minor number won't get reused until the process closes the file.

That's how the usb-serial code always worked, this is nothing new at
all.

> For example, if you run minicom over /dev/ttyUSB0, unplug the USB
> device while minicom is running, and then plug it in again before
> exiting minicom, it will reappear as /dev/ttyUSB1 instead of
> /dev/ttyUSB0 (which will be gone).

Exactly.  People are used to this by now, it shouldn't be a supprise :)

thanks,

greg k-h
