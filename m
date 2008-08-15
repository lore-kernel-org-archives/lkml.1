Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbYHOWiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbYHOWiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 18:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbYHOWiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 18:38:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55092 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbYHOWiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 18:38:11 -0400
Message-ID: <48A6037B.6030202@zytor.com>
Date: Fri, 15 Aug 2008 15:30:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, srostedt@redhat.com
Subject: Re: [PATCH] ftrace: use only 5 byte nops for x86
References: <alpine.DEB.1.10.0808141755030.2911@gandalf.stny.rr.com> <48A4C491.4050301@goop.org> <20080815092231.GB22209@elte.hu>
In-Reply-To: <20080815092231.GB22209@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>>
>>> TODO: Examine the cpuid to determine the nop to use.
>>>   
>> Don't think that will help in general.  qemu claims its a Pentium II.
> 
> ok. I've applied Steve's patch as it's a good bugfix. The extra paranoia 
> about faulting on 0x90 seems excessive but doesnt hurt ;-)
> 

I think what we need to do is to test the NOPL instruction and create a 
Linux-specific CPUID bit for it.  I'll do that and submit to tip:x86/cpu.

	-hpa
