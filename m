Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbYHMUWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbYHMUWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYHMUW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:22:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388AbYHMUW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:22:28 -0400
Date: Wed, 13 Aug 2008 13:21:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Steven Rostedt <srostedt@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: Efficient x86 and x86_64 NOP microbenchmarks
In-Reply-To: <20080813201532.GR1366@one.firstfloor.org>
Message-ID: <alpine.LFD.1.10.0808131320000.3462@nehalem.linux-foundation.org>
References: <20080813191926.GB15547@Krystal> <48A33D65.4020802@redhat.com> <20080813201532.GR1366@one.firstfloor.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Aug 2008, Andi Kleen wrote:
> 
> Also I must say the whole ftrace noping exercise is pretty pointless without
> avoiding frame pointers because it does save less than what you lose
> unconditionally from the "select FRAME_POINTER"

Andi, you seem to have missed the whole point. This is a _correctness_ 
issue as long as the nop is not a single instruction. And the workaround 
for that is uglier than just making a single-instruction nop.

So the question now is to find a good nop that _is_ a single atomic 
instruction. Your blathering about frame pointers is missing the whole 
point!

			Linus
