Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbXLaXdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbXLaXdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 18:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbXLaXdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 18:33:38 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33609 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750863AbXLaXdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 18:33:37 -0500
Date: Mon, 31 Dec 2007 23:24:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ondrej Zary <linux@rainbow-software.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071231232412.64347335@the-village.bc.nu>
In-Reply-To: <47796363.8060604@zytor.com>
References: <477711DC.5030800@keyaccess.nl>
	<4778FE42.6010003@keyaccess.nl>
	<20071231155600.0b06552c@the-village.bc.nu>
	<200712312122.13739.linux@rainbow-software.org>
	<20071231212525.6940ce70@the-village.bc.nu>
	<47796363.8060604@zytor.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However, assuming a bus clock of 6 MHz should be safe (167 ns).

Agreed - or ISA timings directly. Boxes using WD80x3 are not going to
have a TSC so might as well stick with port 0x80 as they have done just
fine for the past 15 years.

> None of this really helps with *memory-mapped* 8390, though, since 
> memory mapped writes can be posted.  Putting any IOIO transaction in the 

ISA isn't posted only PCI.

PCI 8390 clones seem to be a mix of ASICs and 8390x chips with
some quite disgusting FPGA glue logic.

Alan
