Return-Path: <linux-kernel-owner+w=401wt.eu-S1763774AbXGaXz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763774AbXGaXz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759337AbXGaXzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:55:49 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56833 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759188AbXGaXzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:55:48 -0400
Date: Wed, 1 Aug 2007 01:03:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Haifeng He" <hehaifeng2nd@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Load interrupt code dynamically
Message-ID: <20070801010304.757f4963@the-village.bc.nu>
In-Reply-To: <ab08258e0707311426r32dc15cexb6867648bc6a45a4@mail.gmail.com>
References: <ab08258e0707311426r32dc15cexb6867648bc6a45a4@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> dealing with the concurrency in the kernel. Interrupt is one of them.

Its extremely hard as you've probably noticed by now.

> My first question is, what are other interrupts in the kernel that can
> allow other interrupts
> to be issued? Second question is, how does the kernel switch between

The kernel IRQ handling is pretty flexible. A concious decision was made
many years ago not to try and limit it to do a pageable kernel as RAM was
far cheaper than the pain, and getting cheaper by the day.

> different interrupts? Last, any suggestion on how to change my current
> implementation to enable loading interrupt code dynamically?

Realistically - the one case it is done right now is by the mainframe
people, simply because the underlying hypervisor does it. You probably
have much more chance that way using a microkernel (real one not MACH)
underneath. Still a huge task.
