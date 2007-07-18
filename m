Return-Path: <linux-kernel-owner+w=401wt.eu-S934039AbXGRR13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934039AbXGRR13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbXGRR1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:27:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49333 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752918AbXGRR1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:27:20 -0400
Date: Wed, 18 Jul 2007 18:33:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Dor Laor" <dor.laor@qumranet.com>
Cc: "Avi Kivity" <avi@qumranet.com>, <kvm-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [RFC] Deferred interrupt handling.
Message-ID: <20070718183358.0a0886aa@the-village.bc.nu>
In-Reply-To: <64F9B87B6B770947A9F8391472E032160CC16D06@ehost011-8.exch011.intermedia.net>
References: <005901c7c921$79c006c0$6d401440$@com>
	<20070718123040.615795b7@the-village.bc.nu>
	<64F9B87B6B770947A9F8391472E032160CC16C92@ehost011-8.exch011.intermedia.net>
	<20070718174736.0baf6d0e@the-village.bc.nu>
	<469E43D5.70802@qumranet.com>
	<64F9B87B6B770947A9F8391472E032160CC16D06@ehost011-8.exch011.intermedia.net>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> 	Guest0	-	blocked on I/O
> >>
> >> 	IRQ14 from your hardware
> >> 		Block IRQ14
> >> 		Sent to guest (guest is blocked)
> >>
> >> 	IRQ14 from hard disk
> >> 		Ignored (as blocked)
> >>
> 
> 
> But now the timer will pop and the hard disk will get its irq.
> The guest will be released right after.

How do you plan to do this ? If you unmask the interrupt then it will
immediately jam solid with IRQs from your hardware and the line will be
disabled.
