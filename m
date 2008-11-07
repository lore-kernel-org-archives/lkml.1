Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbYKGXnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbYKGXnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:43:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYKGXnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:43:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41023 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbYKGXn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:43:29 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081107221813.GA18378@flint.arm.linux.org.uk>
References: <20081107221813.GA18378@flint.arm.linux.org.uk> <20081107003816.9b0f947a.akpm@linux-foundation.org> <20081107052336.652868737@polymtl.ca> <20081107053349.861709786@polymtl.ca> <20081106220530.5b0e3a96.akpm@linux-foundation.org> <alpine.LFD.2.00.0811070256450.13034@xanadu.home> <25363.1226056819@redhat.com> <20081107164758.GB22134@Krystal> <20081107201118.GB28600@flint.arm.linux.org.uk> <20081107213610.GC2654@Krystal> 
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: dhowells@redhat.com, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>, Nicolas Pitre <nico@cam.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Date: Fri, 07 Nov 2008 23:41:55 +0000
Message-ID: <9405.1226101315@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> Well, that's where it was - private to ARM.  Then David Howells came
> along and unilaterally - and without reference to anyone as far as I
> can see - moved it to include/linux.
> 
> Neither Nicolas, nor me had any idea that it was going to move into
> include/linux - the first we knew of it was when pulling the change
> from Linus' tree.
> 
> Look, if people in the kernel community can't or won't communicate
> with others (either through malice, purpose or accident), you can
> expect this kind of crap to happen.

Excuse me, Russell, but I sent Nicolas an email prior to doing so asking him
if he had any objections:

	To: Nicolas Pitre <nico@cam.org>
	cc: dhowells@redhat.com
	Subject: Moving asm-arm/cnt32_to_63.h to include/linux/
	Date: Thu, 31 Jul 2008 16:04:04 +0100

	Hi Nicolas,

	Mind if I move include/asm-arm/cnt32_to_63.h to include/linux/?

	I need to use it for MN10300.

	David

He didn't respond.  Not only that, but I copied Nicolas on the patch to make
the move and the patch to make MN10300 use it when I submitted it to Linus on
the 24th September, so it's not like he didn't have plenty of time.  He
certainly saw that because he joined in the discussion of the second patch.
Furthermore, he could've asked Linus to refuse the patch, or to revert it if
it had already gone in.

I suppose I should've cc'd the ARM list too... but why should it adversely
affect ARM?

David
