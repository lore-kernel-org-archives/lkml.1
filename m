Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976Ab0AUBwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab0AUBwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 20:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890Ab0AUBwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 20:52:16 -0500
Received: from netrider.rowland.org ([192.131.102.5]:59250 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753325Ab0AUBwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 20:52:09 -0500
Date: Wed, 20 Jan 2010 20:52:03 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: linux-kernel@vger.kernel.org, <linux-geode@lists.infradead.org>,
       <linux-usb@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: Strange EHCI/OHCI IRQ and other PCI errors on boot with 2.6.32
 (which 2.6.26 did not see) on Geode LX/CS5536.
In-Reply-To: <20100120223855.GQ24305@caffeine.csclub.uwaterloo.ca>
Message-ID: <Pine.LNX.4.44L0.1001202043540.3608-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010, Lennart Sorensen wrote:

> > > If I boot with 'irqpoll' then everything seems fine.
> > > 
> > > Any idea how I can figure out why irqpoll makes it happy?  Does it give
> > > any reports anywhere about misrouted irqs?
> > 
> > Not that I know of.
> 
> That's unfortunate.  After all it would be nice if irqpoll found an
> unhandled irq and called all the other handlers and the irq went away,
> then a report of which handler cleared it would be very helpful.

You could try changing the set of drivers loaded in memory.  For 
example, after booting with irqpoll you can unload ehci-hcd plus some 
other driver, and then load ehci-hcd again.  If the IRQ storm occurs 
then you'll know where to look.

> > Does 2.6.26 fail on the new machine?
> 
> Yes.
> 
> As far as I can tell some machines don't see the problem.  I am still
> investigating that.

Same kernel, initramfs, and everything else?

> > Are you using a .config different from the one that used to work with 
> > 2.6.26?
> 
> Well of course, but not for the USB settings.  It is supposed to be the
> same as far as possible.  I will go compare them in more detail.

What I meant was: Is your current 2.6.26 still built using the same 
.config as the old 2.6.26 which used to work okay?

Alan Stern

