Return-Path: <linux-kernel-owner+w=401wt.eu-S1762785AbXJEOZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762785AbXJEOZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 10:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbXJEOZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 10:25:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52831 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755119AbXJEOZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 10:25:08 -0400
Date: Fri, 5 Oct 2007 10:25:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
cc: linux-kernel@vger.kernel.org, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [IRQ map] VIA C7 CN700 2.6.23-rc9-git USB IRQs
 disabled
In-Reply-To: <Pine.LNX.4.60.0710050105450.4537@poirot.grange>
Message-ID: <Pine.LNX.4.44L0.0710051021230.4446-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007, Guennadi Liakhovetski wrote:

> Booting git snapshot of about 6 hours ago, getting the following:
> 
> USB Universal Host Controller Interface driver v3.0
> ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21
> ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 18
> ACPI: PCI interrupt for device 0000:00:10.0 disabled
> uhci_hcd 0000:00:10.0: init 0000:00:10.0 fail, -16
> uhci_hcd: probe of 0000:00:10.0 failed with error -16

> With "pci=routeirq" it is the same, but then it's "IRQ 17" instead of 18, 
> and the line
> 
> ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21
> 
> is missing. Works with Debian etch default 2.6.18. /proc/interrupts under 
> .23-rc9-...:

What do you get with CONFIG_USB_DEBUG enabled?

Alan Stern

