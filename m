Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbYHNVu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbYHNVu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 17:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbYHNVut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 17:50:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55777 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbYHNVut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 17:50:49 -0400
Message-ID: <48A4A6EE.1070508@zytor.com>
Date: Thu, 14 Aug 2008 14:43:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
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
Subject: Re: [PATCH] x86 alternatives : fix LOCK_PREFIX race with preemptible
 kernel and CPU hotplug
References: <20080814205815.GA14076@Krystal> <20080814212036.GD13814@one.firstfloor.org>
In-Reply-To: <20080814212036.GD13814@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> So, unless these calculus are completely bogus, the difference between the nop
>> and the DS case seems not to be statistically significant.
> 
> My understanding was that the nops only make a measurable difference in the 
> -pg/mcount/ftrace patched out case where every function call starts with a 5
> byte nop.
> 
> Presumably function calls are much more common than lock prefix operations.

Yeah, although the LOCK prefix was measurable.

	-hpa
