Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbZJZR3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbZJZR3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbZJZR3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:29:21 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46571 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbZJZR3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:29:19 -0400
Date: Mon, 26 Oct 2009 10:13:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, avi@redhat.com,
       mtosatti@redhat.com
Subject: Re: [PATCH tip/core/rcu 6/6] rcu: Simplify creating of lockdep
	class for root rcu_node
Message-ID: <20091026171330.GC6317@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091026020253.GA11350@linux.vnet.ibm.com> <20091026065007.GA24908@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026065007.GA24908@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 07:50:07AM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Use lockdep_set_class() to simplify the code and to avoid any additional
> > overhead in the !LOCKDEP case.
> > 
> > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> This signoff order is wrong - first signoff line must be the author of 
> the patch. (which is a pretty general rule with only rare exceptions) 
> 
> This patch was from Peter originally, right? In such cases please add:
> 
>   From: Peter Zijlstra <peterz@infradead.org>
> 
> To the head of the patch. Or, if Peter acked it, add:
> 
>   Acked-by: Peter Zijlstra <peterz@infradead.org>
> 
> SOB lines are strictly only added by people who send patches to you - 
> i.e. it records the patch handling pathway.

I will resubmit with this fixed up, apologies for my confusion.

							Thanx, Paul
