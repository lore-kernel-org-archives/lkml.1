Return-Path: <linux-kernel-owner+w=401wt.eu-S1759745AbYGFVJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745AbYGFVJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 17:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757623AbYGFVJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 17:09:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47526 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756916AbYGFVJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 17:09:31 -0400
Date: Sun, 6 Jul 2008 21:51:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Alan Cox <alan@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: pata_it821x completely broken
Message-ID: <20080706215146.63d9dfd2@lxorguk.ukuu.org.uk>
In-Reply-To: <200807062303.05994.linux@rainbow-software.org>
References: <200807042153.56644.linux@rainbow-software.org>
	<200807051242.00545.linux@rainbow-software.org>
	<20080705154951.GC20937@devserv.devel.redhat.com>
	<200807062303.05994.linux@rainbow-software.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maxtor 7270 AV - is detected by firmware but oopses in Linux:
> 
> pata_it821x: forcing bypass mode.
> pata_it821x: controller in pass through mode.
> ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
> ACPI: PCI Interrupt 0000:00:12.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> 
> IRQ 11
> irq 11: nobody cared (try booting with the "irqpoll" option)
> Pid: 1, comm: swapper Not tainted 2.6.25.3-pentium #5
>  [<c012f48f>] __report_bad_irq+0x24/0x69
>  [<c012f496>] __report_bad_irq+0x2b/0x69

Please file a bug for this - that's upsetting the core libata code
somewhere, perhaps from a left over floating interrupt.

Alan
