Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbZJZR3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbZJZR3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbZJZR3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:29:19 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33597 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbZJZR3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:29:19 -0400
Date: Mon, 26 Oct 2009 10:12:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, avi@redhat.com,
       mtosatti@redhat.com
Subject: Re: [PATCH tip/core/rcu 6/6] rcu: Simplify creating of lockdep
	class for root rcu_node
Message-ID: <20091026171252.GB6317@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091026020253.GA11350@linux.vnet.ibm.com> <4AE55F02.3030803@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE55F02.3030803@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 04:34:10PM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> > diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> > index 599161f..e091b30 100644
> > --- a/kernel/rcutree.h
> > +++ b/kernel/rcutree.h
> > @@ -296,6 +296,8 @@ DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
> >  
> >  #else /* #ifdef RCU_TREE_NONCORE */
> >  
> > +static struct lock_class_key rcu_root_class;
> > +
> 
> I think this line needs to be moved into rcutree.c.

Good point, I will submit a cleanup patch.

> >  /* Forward declarations for rcutree_plugin.h */
> >  static inline void rcu_bootup_announce(void);
> >  long rcu_batches_completed(void);
> 
> For all 6 patches:
> Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Thank you!!!

							Thanx, Paul

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
