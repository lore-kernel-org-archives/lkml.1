Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYIYRc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYIYRc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbYIYRcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:32:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56085 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbYIYRcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:32:50 -0400
Date: Thu, 25 Sep 2008 13:32:47 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Ingo Molnar <mingo@elte.hu>, Martin Bligh <mbligh@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <20080925172054.GC29392@Krystal>
Message-ID: <alpine.DEB.1.10.0809251332360.29802@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com> <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com> <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com>
 <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <20080925162315.GA649@Krystal>
 <alpine.DEB.1.10.0809251232020.27920@gandalf.stny.rr.com> <20080925172054.GC29392@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Sep 2008, Mathieu Desnoyers wrote:

> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > 
> > On Thu, 25 Sep 2008, Mathieu Desnoyers wrote:
> > > The problem with sched_clock is that it gives a 1 HZ timestamp accuracy
> > > for events happening across different CPUs. Within this 1 HZ range, it
> > > uses the TSC and clip when it reaches a max. Good enough for scheduler
> > > or for tracing events on a single CPU, but I think it is not exactly
> > > what we need to reorder events happening across CPUs.
> > > 
> > 
> > 
> > Hmm,
> > 
> > sched_clock gives ns accuracy unless the tsc is disabled. And in that 
> > case, we don't have any CPU clock :-/
> > 
> 
> Even on architectures with non-synchronized TSCs ?

Yep, even on those ;-)

-- Steve
