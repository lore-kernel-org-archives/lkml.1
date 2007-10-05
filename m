Return-Path: <linux-kernel-owner+w=401wt.eu-S1763339AbXJEOu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763339AbXJEOu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 10:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757064AbXJEOuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 10:50:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:51988 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756839AbXJEOuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 10:50:19 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+hD0xI3Duhpx0q/+qpp3zLyweJNf0znsRk+r2LpK
	rROf6fUqq6+I6d
Date: Fri, 5 Oct 2007 16:50:38 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>
cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [IRQ map] VIA C7 CN700 2.6.23-rc9-git USB IRQs
 disabled
In-Reply-To: <Pine.LNX.4.44L0.0710051021230.4446-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.60.0710051628380.10392@poirot.grange>
References: <Pine.LNX.4.44L0.0710051021230.4446-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007, Alan Stern wrote:

> On Fri, 5 Oct 2007, Guennadi Liakhovetski wrote:
> 
> > Booting git snapshot of about 6 hours ago, getting the following:
> > 
> > USB Universal Host Controller Interface driver v3.0
> > ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21
> > ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 18
> > ACPI: PCI interrupt for device 0000:00:10.0 disabled
> > uhci_hcd 0000:00:10.0: init 0000:00:10.0 fail, -16
> > uhci_hcd: probe of 0000:00:10.0 failed with error -16
> 
> > With "pci=routeirq" it is the same, but then it's "IRQ 17" instead of 18, 
> > and the line
> > 
> > ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21
> > 
> > is missing. Works with Debian etch default 2.6.18. /proc/interrupts under 
> > .23-rc9-...:
> 
> What do you get with CONFIG_USB_DEBUG enabled?

Will try as soon as my bisect is done. Interestingly, both problems with 
this system - this one and http://lkml.org/lkml/2007/10/4/417 so far 
regress together - already somewhere after 23-rc6 and both USB and 
i2c-viapro still work... Might also be some configuration options that got 
lost while bisecting .22 - .23-rc9.

Thanks
Guennadi
---
Guennadi Liakhovetski
