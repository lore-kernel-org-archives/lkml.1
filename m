Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYJCAcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYJCAcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 20:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbYJCAcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 20:32:23 -0400
Received: from www.tglx.de ([62.245.132.106]:56539 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbYJCAcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 20:32:22 -0400
Date: Fri, 3 Oct 2008 02:26:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded interrupt
 handlers
In-Reply-To: <1222989842.2995.240.camel@laptop-eth>
Message-ID: <alpine.LFD.1.10.0810030215190.5549@apollo.tec.linutronix.de>
References: <20081001223213.078984344@linutronix.de>  <1222912413.2995.80.camel@laptop-eth.lan>  <alpine.DEB.1.10.0810021052010.19018@gandalf.stny.rr.com>  <1222962525.2995.100.camel@laptop-eth>  <alpine.LFD.1.10.0810022004520.5549@apollo.tec.linutronix.de>
  <1222974254.2995.144.camel@laptop-eth>  <20081002192827.GA2950@elte.hu>  <1222978145.2995.172.camel@laptop-eth>  <alpine.DEB.1.10.0810021612280.2919@gandalf.stny.rr.com>  <1222980485.2995.186.camel@laptop-eth>  <alpine.DEB.1.10.0810021652370.24442@gandalf.stny.rr.com>
  <1222983008.2995.205.camel@laptop-eth>  <alpine.DEB.1.10.0810021749230.24442@gandalf.stny.rr.com> <1222989842.2995.240.camel@laptop-eth>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008, Daniel Walker wrote:
> On Thu, 2008-10-02 at 18:28 -0400, Steven Rostedt wrote:
> > > > Why are you bringing up real time in this thread?? The thread has
> > > > absolutely nothing to do with real time. This thread is about a better
> > > > way to handle interrupt handlers.
> > > 
> > > I'm concerned about the connection between the two, which is what I'm
> > > commenting on.
> > 
> > Well, please take that up separately. Do you see these patches going
> > into the -rt tree?  No, they are going in mainline. We will deal with
> > them for -rt when the time comes.
> 
> It's an RFC after all, it's not going into anything at this point..

Because you are deciding what's going into mainline, right ?

> > You are bringing up concerns about mainline changes with something that
> > is maintained outside the mainline tree.  Changes to mainline have never
> > been influenced by changes maintained outside of mainline.
> 
> Again it's an RFC .. It's not going into mainline.. 

You made such a statement vs. hrtimers some time ago. 

> > Yes Daniel, I know. But this is not a conversation. This is a email thread
> > that is talking about changes to mainline. The mainline kernel developers
> > really don't care about any issues that these changes will do to the
> > real time project. The real time project is a niche, and is currently
> > outside the mainline tree. Hence, lets stop bothering mainline 
> > developers with our issues.
> 
> Your speaking for a lot of developers.. It's an RFC, it's coming from
> real time developers, it's real time connected, and this is the real
> time development list ..

This RFC patch is from a mainline developer/ maintainer who happens to
be a real time developer as well.

Welcome to my real time incoherent nonsense filter

	tglx
