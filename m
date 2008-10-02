Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbYJBVF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbYJBVF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 17:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbYJBVFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 17:05:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35059 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbYJBVFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 17:05:14 -0400
Date: Thu, 2 Oct 2008 17:05:10 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded interrupt
 handlers
In-Reply-To: <1222980485.2995.186.camel@laptop-eth>
Message-ID: <alpine.DEB.1.10.0810021652370.24442@gandalf.stny.rr.com>
References: <20081001223213.078984344@linutronix.de>  <1222912413.2995.80.camel@laptop-eth.lan>  <alpine.DEB.1.10.0810021052010.19018@gandalf.stny.rr.com>  <1222962525.2995.100.camel@laptop-eth>  <alpine.LFD.1.10.0810022004520.5549@apollo.tec.linutronix.de>
  <1222974254.2995.144.camel@laptop-eth>  <20081002192827.GA2950@elte.hu>  <1222978145.2995.172.camel@laptop-eth>  <alpine.DEB.1.10.0810021612280.2919@gandalf.stny.rr.com> <1222980485.2995.186.camel@laptop-eth>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2 Oct 2008, Daniel Walker wrote:
> > 
> > What Ingo is telling you is:
> > 
> >   - RT needs threaded interrupts.
> > 
> >   - Threaded interrupts do not need RT
> > 
> > My dog is an Italian Greyhound.
> > 
> > Italian Greyhound is a dog, but
> > a dog is not an Italian Greyhound.
> 
> My comments are basically bidirectional , so what your saying doesn't
> make any sense .. I said basically, that dogs and "Italian Greyhounds"
> have _some_ connection .. Why are we even debating this.


Let's look at your original comments:

> I'm not clear on your direction here.. I don't have a problem with a
> mass driver audit, which I think is what your suggesting with this patch
> set .. However, a mass audit like that would push a fully real time
> system out for quite some time..

Why are you bringing up real time in this thread?? The thread has
absolutely nothing to do with real time. This thread is about a better
way to handle interrupt handlers.

> 
> I also don't see a clear connection between these changes and ultimately
> removing spinlock level latency in the kernel. I realize you don't
> address that in your comments, but this is part of the initiative to
> remove spinlock level latency..

Again, this thread has nothing to do with removing spinlock level latency.
The reason Thomas did not address this is because it is OFF TOPIC!!!!

> 
> So with this set of changes and in terms of real time, I'm wonder your
> going with this ?

You brought in this relationship with real time, just because real time 
uses threaded interrupts. This thread has nothing to do with real time. 
That is what Ingo, Thomas and myself are trying to ge through to you.

The strong reaction from Thomas is that you just brought up something that 
is completely off topic.

Basically, drop the real time topic from this thread. It's not related. 
Yes real time addresses threaded interrupts, but just because we are 
talking about threaded interrupts does not mean we are talking about real 
time.

Actually my analogy with dogs and IG's is wrong. The pipe and crap analogy 
is better. Crap uses pipes to get out of the house. But if I'm talking 
about pipes, I don't want to hear about crap.

We are debating this because YOU brought it up!

-- Steve

