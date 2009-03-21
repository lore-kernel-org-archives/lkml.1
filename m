Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbZCUKCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbZCUKCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 06:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbZCUKBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 06:01:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33391 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867AbZCUKBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 06:01:50 -0400
Date: Sat, 21 Mar 2009 11:01:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090321100129.GC7201@elte.hu>
References: <alpine.DEB.2.00.0903191309170.16987@gandalf.stny.rr.com> <20090320174331.GH6698@linux.vnet.ibm.com> <20090320183642.GA2070@elte.hu> <20090320183849.GA3657@elte.hu> <20090320191926.GJ6698@linux.vnet.ibm.com> <20090320192721.GI6224@elte.hu> <20090320194617.GA5934@nowhere> <20090320195414.GA24129@elte.hu> <20090320204848.GA6044@nowhere> <alpine.DEB.2.00.0903201705380.13615@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903201705380.13615@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Fri, 20 Mar 2009, Frederic Weisbecker wrote:
> > > >  
> > > >  	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
> > > > -	set_user_nice(current, 19);
> > > > +	set_user_nice(current, -1);
> > > >  	if (irqreader && cur_ops->irqcapable)
> > > >  		setup_timer_on_stack(&t, rcu_torture_timer, 0);
> > > 
> > > i dont have a reproducer right now. Can you trigger it with latest 
> > > -tip, which has this commit included:
> > > 
> > > 04cb9ac: rcu: rcu_barrier VS cpu_hotplug: Ensure callbacks in dead cpu are migrated to o
> > > 
> > > ?
> > > 
> > > 	Ingo
> > 
> > 
> > I tested three times the same things but with 04cb9ac and... it didn't triggered
> > anymore :-)
> 
> So lets hope that was the culprit.
> 
> Great work Frederic!

No new lockups of this nature in overnight -tip testing. It's still 
a bit too early to tell for sure but it's promising ;-)

	Ingo
