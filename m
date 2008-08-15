Return-Path: <linux-kernel-owner+w=401wt.eu-S1758314AbYHOXAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314AbYHOXAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 19:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbYHOXAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 19:00:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40660 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbYHOXAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 19:00:20 -0400
Message-ID: <48A608AF.5050307@zytor.com>
Date: Fri, 15 Aug 2008 15:52:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, srostedt@redhat.com
Subject: Re: [PATCH] ftrace: use only 5 byte nops for x86
References: <alpine.DEB.1.10.0808141755030.2911@gandalf.stny.rr.com> <48A4C491.4050301@goop.org> <20080815092231.GB22209@elte.hu> <48A6037B.6030202@zytor.com> <alpine.LFD.1.10.0808151542330.3324@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808151542330.3324@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
>>>
>> I think what we need to do is to test the NOPL instruction and create a
>> Linux-specific CPUID bit for it.  I'll do that and submit to tip:x86/cpu.
> 
> I also suspect that we'd really be much better off just fixing the generic 
> NOP tables for the 5-byte nop. As far as I could tell, from all the 
> numbers that have been posted, absolutely _none_ show that there is any 
> point at all to the 2-instruction 3/2-byte sequence.
> 
> So instead of having a magic special ftrace-only thing, why not just do it 
> right, and fix the generic 5-byte nop sequence?
> 

There is that, too.  The two are orthogonal.

	-hpa
