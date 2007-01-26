Return-Path: <linux-kernel-owner+w=401wt.eu-S1161031AbXAZKWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161031AbXAZKWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 05:22:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161037AbXAZKWC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 05:22:02 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37001 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161031AbXAZKWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 05:22:00 -0500
Date: Fri, 26 Jan 2007 10:33:31 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "Stephen Evanchik" <evanchsa@gmail.com>
Cc: "Luming Yu" <luming.yu@gmail.com>,
       "Stefan Priebe - FH" <studium@profihost.com>,
       linux-kernel@vger.kernel.org
Subject: Re: SATA ahci Bug in 2.6.19.x
Message-ID: <20070126103331.191cda3b@localhost.localdomain>
In-Reply-To: <a71293c20701252218y326c392ehb7ee5127436d29bd@mail.gmail.com>
References: <45B46FA0.2060901@profihost.com>
	<a71293c20701220600v426f0efdyc23dd945852f71c0@mail.gmail.com>
	<3877989d0701251925i8bbc09emd8dcad8d098195d2@mail.gmail.com>
	<a71293c20701252046o73fabcb9v611dedbb6f6b90e3@mail.gmail.com>
	<3877989d0701252122s7e5ad92fo5496daf566fd9f97@mail.gmail.com>
	<a71293c20701252218y326c392ehb7ee5127436d29bd@mail.gmail.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The only difference is that I don't see the "ACPI: PCI Interrupt
> 0000:00:0f.0[B] -> GSI
> 21 (level, low) -> IRQ 19" printk. The driver is AHCI but the device
> is a VIA chip.
> 
> I'll get a caputre of the boot log when I find my serial cable. This
> could be related to the VIA PIC quirks that was changed by Alan.

Stuff a printk in and check by all means but _in theory_ the VIA quirk
shouldn't touch IRQ > 15 as those are not PIC but APIC routed.
