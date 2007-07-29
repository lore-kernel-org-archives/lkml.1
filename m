Return-Path: <linux-kernel-owner+w=401wt.eu-S932855AbXG2P0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbXG2P0e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934332AbXG2PTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:19:52 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3427 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934321AbXG2PTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:19:50 -0400
Date: Sun, 29 Jul 2007 11:19:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Mark Hindley <mark@hindley.org.uk>
cc: linux-kernel@vger.kernel.org, <linux-usb-users@lists.sourceforge.net>
Subject: Re: [Linux-usb-users] [REGRESSION] 2.6.23-rc1: uhci_hcd. irq 4:
 nobody cared
In-Reply-To: <20070729130105.GB27939@hindley.org.uk>
Message-ID: <Pine.LNX.4.44L0.0707291118360.10113-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jul 2007, Mark Hindley wrote:

> Hi,
> 
> I have just tried 2.6.23-rc1 on my Acer Aspire 1350.
> 
> On boot I get the following error as the uhci_hcd module is loaded:
> 
> Jul 28 18:23:20 mercury kernel: ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKA] -> GSI 4 (level, low) -> IRQ 4
> Jul 28 18:23:20 mercury kernel: uhci_hcd 0000:00:10.0: UHCI Host Controller
> Jul 28 18:23:20 mercury kernel: uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
> Jul 28 18:23:20 mercury kernel: irq 4: nobody cared (try booting with the "irqpoll" option)

Did it work okay with older kernels?  What does /proc/interrupts say in 
both 2.6.23-rc1 and in a working kernel?

Alan Stern

