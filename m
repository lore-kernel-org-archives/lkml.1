Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbXLaVfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbXLaVfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 16:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbXLaVfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 16:35:45 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60858 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751809AbXLaVfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 16:35:45 -0500
Date: Mon, 31 Dec 2007 21:25:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071231212525.6940ce70@the-village.bc.nu>
In-Reply-To: <200712312122.13739.linux@rainbow-software.org>
References: <477711DC.5030800@keyaccess.nl>
	<4778FE42.6010003@keyaccess.nl>
	<20071231155600.0b06552c@the-village.bc.nu>
	<200712312122.13739.linux@rainbow-software.org>
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

> What about HP PCLan 16/TP+ cards? I have one that runs 24/7 in a 486 box 
> (2.6.20.6 kernel) and one spare. It has some VLSI HP chip and also ST-NIC 
> DP83902AV - is that a good candidate for testing?

What are you trying to test. The documentation explicitly says you need
the delays and that the delays are in bus clocks not microseconds. That
means the existing code is correct and it needs a delay dependant on the
ISA bus clock frequency (somewhere between 6 and 12MHz). Note that the
delay depends on the bus clock frequency not time.

We don't do overclocking, we don't support overclocking, please do not
overclock your ethernet chip.

Alan
