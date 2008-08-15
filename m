Return-Path: <linux-kernel-owner+w=401wt.eu-S1760550AbYHORdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550AbYHORdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 13:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbYHORdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 13:33:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753952AbYHORdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 13:33:41 -0400
Date: Fri, 15 Aug 2008 10:31:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86 : spinlock use LOCK_PREFIX
In-Reply-To: <20080815165659.GD21138@Krystal>
Message-ID: <alpine.LFD.1.10.0808151031310.3324@nehalem.linux-foundation.org>
References: <20080814205815.GA14076@Krystal> <alpine.LFD.1.10.0808150854140.3324@nehalem.linux-foundation.org> <20080815165659.GD21138@Krystal>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Aug 2008, Mathieu Desnoyers wrote:
> 
> Unless there a rationale for this, I think these be changed to LOCK_PREFIX
> too.
> 
> grep "lock ;" include/asm-x86/spinlock.h
>          "lock ; cmpxchgw %w1,%2\n\t"
>   asm volatile("lock ; xaddl %0, %1\n"
>          "lock ; cmpxchgl %1,%2\n\t"

Ack.

		Linus
