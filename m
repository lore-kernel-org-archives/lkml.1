Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbYKQPoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbYKQPoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYKQPn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:43:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50575 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYKQPn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:43:57 -0500
Date: Mon, 17 Nov 2008 10:43:55 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Paul Mackerras <paulus@samba.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/7] ftrace, PPC: do not latency trace idle
In-Reply-To: <18720.59484.266300.486911@drongo.ozlabs.ibm.com>
Message-ID: <alpine.DEB.1.10.0811171042280.2919@gandalf.stny.rr.com>
References: <20081116212428.938752312@goodmis.org> <20081116212515.093117788@goodmis.org> <18720.59484.266300.486911@drongo.ozlabs.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 17 Nov 2008, Paul Mackerras wrote:

> Steven Rostedt writes:
> 
> > When idle is called, interrupts are disabled, but the idle function
> > will still wake up on an interrupt. The problem is that the interrupt
> > disabled latency tracer will take this call to idle as a latency.
> > 
> > This patch disables the latency tracing when going into idle.
> 
> Patch looks OK, but what is the connection with ftrace?

Ah, that patch has been sitting on my box for some time. It has to deal 
with the latency tracer and not the dynamic tracing part of ftrace. I 
added it because it is PPC ftrace related and to get it off my box. But 
this is not have anything to do with the rest of the patches.

-- Steve

