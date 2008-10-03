Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871AbYJCOo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbYJCOo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 10:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbYJCOoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 10:44:18 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:43172 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbYJCOoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:44:18 -0400
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded
	interrupt handlers
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
In-Reply-To: <alpine.LFD.1.10.0810030215190.5549@apollo.tec.linutronix.de>
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
	 <1222983008.2995.205.camel@laptop-eth>
	 <alpine.DEB.1.10.0810021749230.24442@gandalf.stny.rr.com>
	 <1222989842.2995.240.camel@laptop-eth>
	 <alpine.LFD.1.10.0810030215190.5549@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 07:44:13 -0700
Message-Id: <1223045053.2995.251.camel@laptop-eth>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-03 at 02:26 +0200, Thomas Gleixner wrote:
> On Thu, 2 Oct 2008, Daniel Walker wrote:
> > On Thu, 2008-10-02 at 18:28 -0400, Steven Rostedt wrote:
> > > > > Why are you bringing up real time in this thread?? The thread has
> > > > > absolutely nothing to do with real time. This thread is about a better
> > > > > way to handle interrupt handlers.
> > > > 
> > > > I'm concerned about the connection between the two, which is what I'm
> > > > commenting on.
> > > 
> > > Well, please take that up separately. Do you see these patches going
> > > into the -rt tree?  No, they are going in mainline. We will deal with
> > > them for -rt when the time comes.
> > 
> > It's an RFC after all, it's not going into anything at this point..
> 
> Because you are deciding what's going into mainline, right ?

You flagged this as an RFC, typically that means it's a work in
progress .. Usually a work in progress does go into mainline.

> > > You are bringing up concerns about mainline changes with something that
> > > is maintained outside the mainline tree.  Changes to mainline have never
> > > been influenced by changes maintained outside of mainline.
> > 
> > Again it's an RFC .. It's not going into mainline.. 
> 
> You made such a statement vs. hrtimers some time ago. 

hrtimers didn't go RFC then straight to mainline either.

> > > Yes Daniel, I know. But this is not a conversation. This is a email thread
> > > that is talking about changes to mainline. The mainline kernel developers
> > > really don't care about any issues that these changes will do to the
> > > real time project. The real time project is a niche, and is currently
> > > outside the mainline tree. Hence, lets stop bothering mainline 
> > > developers with our issues.
> > 
> > Your speaking for a lot of developers.. It's an RFC, it's coming from
> > real time developers, it's real time connected, and this is the real
> > time development list ..
> 
> This RFC patch is from a mainline developer/ maintainer who happens to
> be a real time developer as well.

And is submitting a real time core features.

> Welcome to my real time incoherent nonsense filter

You ask for comments, than get upset when you get some .. If anyone
needs to be filtered it's you.

Daniel

