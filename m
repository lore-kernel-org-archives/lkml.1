Return-Path: <linux-kernel-owner+w=401wt.eu-S1759864AbZCTShV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864AbZCTShV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 14:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbZCTShH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 14:37:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43144 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbZCTShG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 14:37:06 -0400
Date: Fri, 20 Mar 2009 19:36:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090320183642.GA2070@elte.hu>
References: <20090318031423.981603258@goodmis.org> <20090318055924.GA24627@elte.hu> <20090318073903.GA31341@elte.hu> <20090319073357.GA14615@elte.hu> <alpine.DEB.2.00.0903191309170.16987@gandalf.stny.rr.com> <20090320174331.GH6698@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320174331.GH6698@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Thu, Mar 19, 2009 at 01:21:47PM -0400, Steven Rostedt wrote:
> > 
> > I'm still not able to reproduce, but...
> > 
> > On Thu, 19 Mar 2009, Ingo Molnar wrote:
> > 
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > these latest ftrace changes caused a lockup on a -tip testsystem:
> > > 
> > > Note, even with Rusty's offstack-cpumask fix applied (in latest 
> > > -tip), i can reproduce a lockup:
> > > 
> 
> [ . . . ]
> 
> > This looks like it is RCU/stop_machine related. The CPU is stuck in
> > in stop_machine? I see that rcu_torture is running. Does this go away if 
> > you turn off rcu_torture?
> 
> Grasping at straws...  Does Lai's rcu_barrier() fix help?

which one is that?

	Ingo
