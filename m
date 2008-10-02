Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYJBUs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYJBUs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 16:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbYJBUsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 16:48:19 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:30096 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbYJBUsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 16:48:18 -0400
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
In-Reply-To: <alpine.DEB.1.10.0810021612280.2919@gandalf.stny.rr.com>
References: <20081001223213.078984344@linutronix.de>
	 <1222912413.2995.80.camel@laptop-eth.lan>
	 <alpine.DEB.1.10.0810021052010.19018@gandalf.stny.rr.com>
	 <1222962525.2995.100.camel@laptop-eth>
	 <alpine.LFD.1.10.0810022004520.5549@apollo.tec.linutronix.de>
	 <1222974254.2995.144.camel@laptop-eth>  <20081002192827.GA2950@elte.hu>
	 <1222978145.2995.172.camel@laptop-eth>
	 <alpine.DEB.1.10.0810021612280.2919@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Thu, 02 Oct 2008 13:48:05 -0700
Message-Id: <1222980485.2995.186.camel@laptop-eth>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-02 at 16:14 -0400, Steven Rostedt wrote:
> On Thu, 2 Oct 2008, Daniel Walker wrote:
> 
> > On Thu, 2008-10-02 at 21:28 +0200, Ingo Molnar wrote:
> > > * Daniel Walker <dwalker@mvista.com> wrote:
> > > 
> > > > > > Clearly threading irq handlers does have something to do with real 
> > > > > > time, unless this patch isn't actually threading anything ..
> > > 
> > > Well, that's clearly wrong: threaded IRQ handlers are not tied to 
> > > real-time in any way. Yes, they can be used for RT too but as far as the 
> > > upstream kernel is involved that's at most an afterthought.
> > 
> > You contradict yourself .. I said "Clearly threading irq handlers does
> 
> No he did not.

Yes, he did.

> > have something to do with real time" then you say "they can be used for 
> > RT too" .. So my comments are clearly correct , they have "something" to
> > do with real time. There exists a relationship of some kind or type.
> 
> 
> What Ingo is telling you is:
> 
>   - RT needs threaded interrupts.
> 
>   - Threaded interrupts do not need RT
> 
> My dog is an Italian Greyhound.
> 
> Italian Greyhound is a dog, but
> a dog is not an Italian Greyhound.

My comments are basically bidirectional , so what your saying doesn't
make any sense .. I said basically, that dogs and "Italian Greyhounds"
have _some_ connection .. Why are we even debating this.

Daniel

