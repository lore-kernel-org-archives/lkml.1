Return-Path: <linux-kernel-owner+w=401wt.eu-S1753713Ab0ATWG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab0ATWG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 17:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344Ab0ATWG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 17:06:57 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:57144 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751672Ab0ATWG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 17:06:56 -0500
Date: Wed, 20 Jan 2010 17:06:53 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: linux-kernel@vger.kernel.org, <linux-geode@lists.infradead.org>,
       <linux-usb@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: Strange EHCI/OHCI IRQ and other PCI errors on boot with 2.6.32
 (which 2.6.26 did not see) on Geode LX/CS5536.
In-Reply-To: <20100120214556.GP24305@caffeine.csclub.uwaterloo.ca>
Message-ID: <Pine.LNX.4.44L0.1001201704360.1360-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010, Lennart Sorensen wrote:

> On Wed, Jan 20, 2010 at 03:20:46PM -0500, Alan Stern wrote:
> > Okay, this means that something else is affecting the IRQ line.
> 
> Yep.  I went and disabled irq5 on the LPC bus, and that didn't help.
> 
> > > Interestingly the number of interrupts listed in /proc/interrupts is
> > > exactly 300000.
> > 
> > That's probably because the kernel disabled the IRQ after 100000 
> > unhandled interrupts, and re-enabled it each time a new device was
> > registered for that IRQ.
> 
> Certainly seems to be the case.
> 
> > Or you could just stop using USB on the old box.  :-)
> 
> Well I just tried another box, and same thing.
> 
> If I boot with 'irqpoll' then everything seems fine.
> 
> Any idea how I can figure out why irqpoll makes it happy?  Does it give
> any reports anywhere about misrouted irqs?

Not that I know of.

Does 2.6.26 fail on the new machine?

Are you using a .config different from the one that used to work with 
2.6.26?

Alan Stern

