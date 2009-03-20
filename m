Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbZCTVGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbZCTVGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 17:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbZCTVGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 17:06:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39385 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbZCTVGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 17:06:02 -0400
Date: Fri, 20 Mar 2009 17:05:58 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
In-Reply-To: <20090320204848.GA6044@nowhere>
Message-ID: <alpine.DEB.2.00.0903201705380.13615@gandalf.stny.rr.com>
References: <20090318073903.GA31341@elte.hu> <20090319073357.GA14615@elte.hu> <alpine.DEB.2.00.0903191309170.16987@gandalf.stny.rr.com> <20090320174331.GH6698@linux.vnet.ibm.com> <20090320183642.GA2070@elte.hu> <20090320183849.GA3657@elte.hu>
 <20090320191926.GJ6698@linux.vnet.ibm.com> <20090320192721.GI6224@elte.hu> <20090320194617.GA5934@nowhere> <20090320195414.GA24129@elte.hu> <20090320204848.GA6044@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 20 Mar 2009, Frederic Weisbecker wrote:
> > >  
> > >  	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
> > > -	set_user_nice(current, 19);
> > > +	set_user_nice(current, -1);
> > >  	if (irqreader && cur_ops->irqcapable)
> > >  		setup_timer_on_stack(&t, rcu_torture_timer, 0);
> > 
> > i dont have a reproducer right now. Can you trigger it with latest 
> > -tip, which has this commit included:
> > 
> > 04cb9ac: rcu: rcu_barrier VS cpu_hotplug: Ensure callbacks in dead cpu are migrated to o
> > 
> > ?
> > 
> > 	Ingo
> 
> 
> I tested three times the same things but with 04cb9ac and... it didn't triggered
> anymore :-)

So lets hope that was the culprit.

Great work Frederic!

-- Steve

