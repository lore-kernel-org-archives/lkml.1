Return-Path: <linux-kernel-owner+w=401wt.eu-S1760317AbZJOJXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317AbZJOJXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbZJOJXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:23:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56872 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608AbZJOJXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:23:13 -0400
Date: Thu, 15 Oct 2009 11:21:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, npiggin@suse.de,
       jens.axboe@oracle.com
Subject: Re: [PATCH tip/core/rcu 0/6] rcu: fix synchronize_rcu_expedited(),
	update docs, improve perf
Message-ID: <20091015092155.GD10546@elte.hu>
References: <20091014171517.GA13635@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014171517.GA13635@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> This patchset contains a bug fix, a performance improvement, and 
> documentation updates:
> 
> o	Update Documentation/RCU/trace.txt to reflect recent changes
> 	(including the removal of rcupreempt.c).

i've applied this to the .33 queue.

> 
> o	Fix to the severe performance problem with excessive IPIs and
> 	lock contention in presence of very large (but legal) numbers
> 	of RCU callbacks (reported by Nick Piggin).

i've applied this to the .32 queue.

> o	Stopgap fix for a bug in TREE_PREEMPT_RCU's implementation of
> 	synchronize_rcu_expedited().  This fix is correct, but no faster
> 	than synchronize_rcu().
> 
> o	Add exports for the updated synchronize_rcu_expedited()
> 	implementation, which moved from a static inline in
> 	include/linux/rcupdate.h to a separately compiled function
> 	in kernel/rcutree_plugin.h.

i've merged these two into the same commit and applied it to the .32 
queue.

> o	Add the new rnp->blocked_tasks field to the rcuhier trace file
> 	in debugfs.
> 
> o	Update the Documentation/RCU/trace.txt documentation to include
> 	the rnp->blocked_tasks tracing.

i've applied these to the .33 queue as well. (both tracing and 
documentation is not urgent material.) I also did minor edits to the 
changelogs.

Thanks Paul!

	Ingo
