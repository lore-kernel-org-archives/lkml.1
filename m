Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbYJBVag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbYJBVag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 17:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbYJBVa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 17:30:26 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:46260 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbYJBVa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 17:30:26 -0400
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded
	interrupt handlers
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
In-Reply-To: <alpine.DEB.1.10.0810021652370.24442@gandalf.stny.rr.com>
References: <20081001223213.078984344@linutronix.de>
	 <1222912413.2995.80.camel@laptop-eth.lan>
	 <alpine.DEB.1.10.0810021052010.19018@gandalf.stny.rr.com>
	 <1222962525.2995.100.camel@laptop-eth>
	 <alpine.LFD.1.10.0810022004520.5549@apollo.tec.linutronix.de>
	 <1222974254.2995.144.camel@laptop-eth>  <20081002192827.GA2950@elte.hu>
	 <1222978145.2995.172.camel@laptop-eth>
	 <alpine.DEB.1.10.0810021612280.2919@gandalf.stny.rr.com>
	 <1222980485.2995.186.camel@laptop-eth>
	 <alpine.DEB.1.10.0810021652370.24442@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Thu, 02 Oct 2008 14:30:08 -0700
Message-Id: <1222983008.2995.205.camel@laptop-eth>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-02 at 17:05 -0400, Steven Rostedt wrote:

> Why are you bringing up real time in this thread?? The thread has
> absolutely nothing to do with real time. This thread is about a better
> way to handle interrupt handlers.

I'm concerned about the connection between the two, which is what I'm
commenting on.

> > 
> > I also don't see a clear connection between these changes and ultimately
> > removing spinlock level latency in the kernel. I realize you don't
> > address that in your comments, but this is part of the initiative to
> > remove spinlock level latency..
> 
> Again, this thread has nothing to do with removing spinlock level latency.
> The reason Thomas did not address this is because it is OFF TOPIC!!!!

If they are connected (which I think we established) , then it's not out
of line for me to discuss the direction of these changes as related to
other components of real time.

> > 
> > So with this set of changes and in terms of real time, I'm wonder your
> > going with this ?
> 
> You brought in this relationship with real time, just because real time 
> uses threaded interrupts. This thread has nothing to do with real time. 
> That is what Ingo, Thomas and myself are trying to ge through to you.

You know Steven, often times you start a conversation and you have no
idea where it will end up.. You can't always control which direction it
will go..

> The strong reaction from Thomas is that you just brought up something that 
> is completely off topic.

We already debated this fact Steven. real time and this type of
threading are connected. It's not off topic to discuss connected
components.

If the intent here is to totally disconnect these threading patches from
any type of real time in the future, then that's a good answer to my
original question .. That these changes have no future what so ever in
regards to real time.

If they will be used in the future for real time then we should discuss
it. I don't think that's off topic at all.

> Basically, drop the real time topic from this thread. It's not related. 
> Yes real time addresses threaded interrupts, but just because we are 
> talking about threaded interrupts does not mean we are talking about real 
> time.

I don't see why you are so concerned with this.. Real time is taboo now?

Daniel

