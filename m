Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbZIRR2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbZIRR2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 13:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757010AbZIRR2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 13:28:18 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39994 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756986AbZIRR2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 13:28:17 -0400
Date: Fri, 18 Sep 2009 10:28:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu
Subject: [PATCH tip/core/rcu] RCU whitespace fixes
Message-ID: <20090918172819.GA24405@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a number of whitespace ^Ierrors in the include/linux/rcu* and the 
kernel/rcu* files.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/rculist_nulls.h |    2 +-
 include/linux/rcupdate.h      |    6 +++---
 include/linux/rcutree.h       |    2 +-
 kernel/rcupdate.c             |    4 ++--
 kernel/rcutorture.c           |    4 ++--
 kernel/rcutree.c              |    2 +-
 kernel/rcutree.h              |    2 +-
 kernel/rcutree_plugin.h       |    4 ++--
 kernel/rcutree_trace.c        |    2 +-
 9 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
index f9ddd03..589a409 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -102,7 +102,7 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
  */
 #define hlist_nulls_for_each_entry_rcu(tpos, pos, head, member) \
 	for (pos = rcu_dereference((head)->first);			 \
-		(!is_a_nulls(pos)) && 			\
+		(!is_a_nulls(pos)) &&			\
 		({ tpos = hlist_nulls_entry(pos, typeof(*tpos), member); 1; }); \
 		pos = rcu_dereference(pos->next))
 
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 39dce83..6fe0363 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1,5 +1,5 @@
 /*
- * Read-Copy Update mechanism for mutual exclusion 
+ * Read-Copy Update mechanism for mutual exclusion
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -18,7 +18,7 @@
  * Copyright IBM Corporation, 2001
  *
  * Author: Dipankar Sarma <dipankar@in.ibm.com>
- * 
+ *
  * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
  * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
  * Papers:
@@ -26,7 +26,7 @@
  * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
  *
  * For detailed explanation of Read-Copy Update mechanism see -
- * 		http://lse.sourceforge.net/locking/rcupdate.html
+ *		http://lse.sourceforge.net/locking/rcupdate.html
  *
  */
 
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 00d08c0..3768277 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -24,7 +24,7 @@
  * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
  *
  * For detailed explanation of Read-Copy Update mechanism see -
- * 	Documentation/RCU
+ *	Documentation/RCU
  */
 
 #ifndef __LINUX_RCUTREE_H
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 28d2f24..37ac454 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -19,7 +19,7 @@
  *
  * Authors: Dipankar Sarma <dipankar@in.ibm.com>
  *	    Manfred Spraul <manfred@colorfullife.com>
- * 
+ *
  * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
  * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
  * Papers:
@@ -27,7 +27,7 @@
  * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
  *
  * For detailed explanation of Read-Copy Update mechanism see -
- * 		http://lse.sourceforge.net/locking/rcupdate.html
+ *		http://lse.sourceforge.net/locking/rcupdate.html
  *
  */
 #include <linux/types.h>
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 328a825..e4b9ce6 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -342,8 +342,8 @@ static struct rcu_torture_ops rcu_ops = {
 	.sync		= synchronize_rcu,
 	.cb_barrier	= rcu_barrier,
 	.stats		= NULL,
-	.irq_capable 	= 1,
-	.name 		= "rcu"
+	.irq_capable	= 1,
+	.name		= "rcu"
 };
 
 static void rcu_sync_torture_deferred_free(struct rcu_torture *p)
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index dd6e743..24f627e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -25,7 +25,7 @@
  * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
  *
  * For detailed explanation of Read-Copy Update mechanism see -
- * 	Documentation/RCU
+ *	Documentation/RCU
  */
 #include <linux/types.h>
 #include <linux/kernel.h>
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index bf8a6f9..8e8287a 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -142,7 +142,7 @@ struct rcu_data {
 	 */
 	struct rcu_head *nxtlist;
 	struct rcu_head **nxttail[RCU_NEXT_SIZE];
-	long		qlen; 	 	/* # of queued callbacks */
+	long		qlen;		/* # of queued callbacks */
 	long		blimit;		/* Upper limit on a processed batch */
 
 #ifdef CONFIG_NO_HZ
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 55c6497..09b7325 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -116,8 +116,8 @@ static void rcu_preempt_note_context_switch(int cpu)
 		 * But first, note that the current CPU must still be
 		 * on line!
 		 */
-	    	WARN_ON_ONCE((rdp->grpmask & rnp->qsmaskinit) == 0);
-	    	WARN_ON_ONCE(!list_empty(&t->rcu_node_entry));
+		WARN_ON_ONCE((rdp->grpmask & rnp->qsmaskinit) == 0);
+		WARN_ON_ONCE(!list_empty(&t->rcu_node_entry));
 		phase = (rnp->gpnum + !(rnp->qsmask & rdp->grpmask)) & 0x1;
 		list_add(&t->rcu_node_entry, &rnp->blocked_tasks[phase]);
 		spin_unlock_irqrestore(&rnp->lock, flags);
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 0ea1bff..c89f5e9 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -20,7 +20,7 @@
  * Papers:  http://www.rdrop.com/users/paulmck/RCU
  *
  * For detailed explanation of Read-Copy Update mechanism see -
- * 		Documentation/RCU
+ *		Documentation/RCU
  *
  */
 #include <linux/types.h>
