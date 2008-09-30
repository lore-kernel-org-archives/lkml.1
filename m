Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbYI3NMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbYI3NMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 09:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYI3NMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 09:12:35 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35337 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761AbYI3NMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 09:12:34 -0400
Date: Tue, 30 Sep 2008 06:10:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] RCU read sched
Message-ID: <20080930131055.GB6716@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48E08B05.7030802@cn.fujitsu.com> <20080929082722.GB18663@elte.hu> <20080929150646.GD11245@Krystal> <20080930100829.GC7557@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930100829.GC7557@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 12:08:30PM +0200, Ingo Molnar wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > (probably already in -tip)
> > 
> > Add rcu_read_lock_sched() and rcu_read_unlock_sched() to rcupdate.h to match the
> > recently added write-side call_rcu_sched() and rcu_barrier_sched(). They also
> > match the no-so-recently-added synchronize_sched().
> > 
> > It will help following matching use of the update/read lock primitives. Those
> > new read lock will replace preempt_disable()/enable() used in pair with
> > RCU-classic synchronization.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > Acked-by: Peter Zijlstra <peterz@infradead.org>
> > CC: Paul E McKenney <paulmck@linux.vnet.ibm.com>
> 
> Paul, does this API extension look good to you?

Yep!!!

> i'll apply it to tip/core/rcu if yes.

Please do!

							Thanx, Paul
