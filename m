Return-Path: <linux-kernel-owner+w=401wt.eu-S1761257AbZCTTTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761257AbZCTTTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761083AbZCTTTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:19:30 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40223 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760843AbZCTTT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:19:29 -0400
Date: Fri, 20 Mar 2009 12:19:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090320191926.GJ6698@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090318031423.981603258@goodmis.org> <20090318055924.GA24627@elte.hu> <20090318073903.GA31341@elte.hu> <20090319073357.GA14615@elte.hu> <alpine.DEB.2.00.0903191309170.16987@gandalf.stny.rr.com> <20090320174331.GH6698@linux.vnet.ibm.com> <20090320183642.GA2070@elte.hu> <20090320183849.GA3657@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320183849.GA3657@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 07:38:49PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > > This looks like it is RCU/stop_machine related. The CPU is 
> > > > stuck in in stop_machine? I see that rcu_torture is running. 
> > > > Does this go away if you turn off rcu_torture?
> > > 
> > > Grasping at straws...  Does Lai's rcu_barrier() fix help?
> > 
> > which one is that?
> 
> ok, found it. Will know in about ~24 hours whether it helps.

http://lkml.org/lkml/2009/3/20/71 was the one I was thinking of, just
to double-check.

							Thanx, Paul
