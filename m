Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbXE3Q3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbXE3Q3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 12:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbXE3Q32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 12:29:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47608 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750743AbXE3Q31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 12:29:27 -0400
Date: Wed, 30 May 2007 12:29:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dan Aloni <da-x@monatomic.org>
cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] Dealing with flaky USB storage devices and
 rootfs
In-Reply-To: <20070530000528.GA1680@localdomain>
Message-ID: <Pine.LNX.4.44L0.0705301223170.5979-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Dan Aloni wrote:

> On Tue, May 29, 2007 at 05:50:49PM -0400, Alan Stern wrote:
> > On Tue, 29 May 2007, Dan Aloni wrote:
> > 
> > > Hello,
> > > 
> > > We have a system where the rootfs is a partition on a USB device,
> > > and I've noticed upon a few rare cases where the USB controller 
> > > loses the connection to the USB device after some uptime (days,
> > > weeks...), and the USB device reappears a very short time later.
> > 
> > That failure mode is pretty uncommon.  More often what happens is the
> > connection remains intact but communication/protocol/firmware/???  
> > errors cause the device to stop working.  It never disappears but it
> > can't be used again without unplugging or power-cycling.
> 
> Yes this is also what I assume happening. i.e. more likely a USB 
> flash disk firmware bug than a controller bug (there are lots of 
> crappy USB flash drives out there).

The only way to tell for certain in some particular case (like yours) 
is to use a USB bus analyzer.  However you probably don't care too much 
about the cause, so long as you can fix it.  Have you tried using a 
different flash drive?

> The specific use case I refer to is with a flash drive embedded 
> inside a locked and closed chassis of a dedicated server. So, 
> anyone repluging it must know what they are doing anyway.

That's fine for you.  But once the code is in the kernel, it affects 
everybody -- including people who don't have dedicated servers with 
closed and locked chassis.

My personal opinion is that it's somewhat distasteful to add software
workarounds for problems caused by bad hardware, unless it's really
impractical to fix or replace the hardware.  But to each his own...

Alan Stern

