Return-Path: <linux-kernel-owner+w=401wt.eu-S1761478AbYHOUfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761478AbYHOUfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 16:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYHOUev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 16:34:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46379 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbYHOUeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:34:50 -0400
Message-ID: <48A5E69E.7060003@zytor.com>
Date: Fri, 15 Aug 2008 13:27:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
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
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] x86 : spinlock use LOCK_PREFIX
References: <20080814205815.GA14076@Krystal> <alpine.LFD.1.10.0808150854140.3324@nehalem.linux-foundation.org> <20080815165659.GD21138@Krystal> <alpine.LFD.1.10.0808151031310.3324@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808151031310.3324@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 15 Aug 2008, Mathieu Desnoyers wrote:
>> Unless there a rationale for this, I think these be changed to LOCK_PREFIX
>> too.
>>
>> grep "lock ;" include/asm-x86/spinlock.h
>>          "lock ; cmpxchgw %w1,%2\n\t"
>>   asm volatile("lock ; xaddl %0, %1\n"
>>          "lock ; cmpxchgl %1,%2\n\t"
> 
> Ack.
> 

Full patch series applied to tip:x86/alternatives; we'll migrate it to 
tip:x86/urgent for upstream delivery after some testing.

	-hpa
