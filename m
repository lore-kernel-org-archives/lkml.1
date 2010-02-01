Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0BAUOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 15:14:11 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42677 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756063Ab0BAUOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 15:14:09 -0500
Date: Mon, 1 Feb 2010 15:14:04 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Catalin Marinas <catalin.marinas@arm.com>
cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>
Subject: Re: USB mass storage and ARM cache coherency
In-Reply-To: <1265045354.25750.52.camel@pc1117.cambridge.arm.com>
Message-ID: <Pine.LNX.4.44L0.1002011512060.1368-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Feb 2010, Catalin Marinas wrote:

> On Fri, 2010-01-29 at 18:54 +0000, Matthew Dharm wrote:
> > HOWEVER, I firmly believe that the cache-management functions belong with
> > the driver that actually talks to the low-level hardware, as that's the
> > only place where you can be 100% certain of what cache operations are
> > needed.  After all, I think someone is working on a USB-over-IP transport,
> > and trying to manage cache at the usb-storage level in that scenario is
> > just silly.
> > 
> > So, let's put this in the HCD drivers and be done with it.
> 
> The patch below is what fixes the I-D cache incoherency issues on ARM. I
> don't particularly like the solution but it seems to be the only one
> available.
> 
> IMHO, Linux should have functions similar to the DMA API but for PIO
> drivers (e.g. pio_map_single/pio_unmap_single) that non-coherent
> architectures can define, otherwise being no-ops. Any thoughts?

You should bring this up on the linux-arm-kernel mailing list and CC:  
the ARM maintainer.  They are the ones most directly affected.

Alan Stern

