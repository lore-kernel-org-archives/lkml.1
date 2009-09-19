Return-Path: <linux-kernel-owner+w=401wt.eu-S1756347AbZISH77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbZISH77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 03:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbZISH76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 03:59:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:42889 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbZISH74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 03:59:56 -0400
Date: Sat, 19 Sep 2009 07:59:19 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090918172819.GA24405@linux.vnet.ibm.com>
References: <20090918172819.GA24405@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Fix whitespace inconsistencies
Message-ID: <tip-a71fca58b7f4abca551ae2256ac08dd9123a03f9@git.kernel.org>
Git-Commit-ID: a71fca58b7f4abca551ae2256ac08dd9123a03f9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Sep 2009 07:59:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a71fca58b7f4abca551ae2256ac08dd9123a03f9
Gitweb:     http://git.kernel.org/tip/a71fca58b7f4abca551ae2256ac08dd9123a03f9
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Fri, 18 Sep 2009 10:28:19 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 19 Sep 2009 08:53:22 +0200

rcu: Fix whitespace inconsistencies

Fix a number of whitespace ^Ierrors in the include/linux/rcu*
and the kernel/rcu* files.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
LKML-Reference: <20090918172819.GA24405@linux.vnet.ibm.com>
[ did more checkpatch fixlets ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/rculist_nulls.h |    2 +-
 include/linux/rcupdate.h      |    6 +++---
 include/linux/rcutree.h       |    2 +-
 kernel/rcupdate.c             |    4 ++--
 kernel/rcutorture.c           |   28 +++++++++++++++-------------
 kernel/rcutree.c              |    2 +-
 kernel/rcutree.h              |    2 +-
 kernel/rcutree_plugin.h       |    3 +--
 kernel/rcutree_trace.c        |    2 +-
 9 files changed, 26 insertions(+), 25 deletions(-)

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
index 328a825..233768f 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -18,7 +18,7 @@
  * Copyright (C) IBM Corporation, 2005, 2006
  *
  * Authors: Paul E. McKenney <paulmck@us.ibm.com>
- *          Josh Triplett <josh@freedesktop.org>
+ *	  Josh Triplett <josh@freedesktop.org>
  *
  * See also:  Documentation/RCU/torture.txt
  */
@@ -50,7 +50,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "
-              "Josh Triplett <josh@freedesktop.org>");
+	      "Josh Triplett <josh@freedesktop.org>");
 
 static int nreaders = -1;	/* # reader threads, defaults to 2*ncpus */
 static int nfakewriters = 4;	/* # fake writer threads */
@@ -110,8 +110,8 @@ struct rcu_torture {
 };
 
 static LIST_HEAD(rcu_torture_freelist);
-static struct rcu_torture *rcu_torture_current = NULL;
-static long rcu_torture_current_version = 0;
+static struct rcu_torture *rcu_torture_current;
+static long rcu_torture_current_version;
 static struct rcu_torture rcu_tortures[10 * RCU_TORTURE_PIPE_LEN];
 static DEFINE_SPINLOCK(rcu_torture_lock);
 static DEFINE_PER_CPU(long [RCU_TORTURE_PIPE_LEN + 1], rcu_torture_count) =
@@ -124,11 +124,11 @@ static atomic_t n_rcu_torture_alloc_fail;
 static atomic_t n_rcu_torture_free;
 static atomic_t n_rcu_torture_mberror;
 static atomic_t n_rcu_torture_error;
-static long n_rcu_torture_timers = 0;
+static long n_rcu_torture_timers;
 static struct list_head rcu_torture_removed;
 static cpumask_var_t shuffle_tmp_mask;
 
-static int stutter_pause_test = 0;
+static int stutter_pause_test;
 
 #if defined(MODULE) || defined(CONFIG_RCU_TORTURE_TEST_RUNNABLE)
 #define RCUTORTURE_RUNNABLE_INIT 1
@@ -267,7 +267,8 @@ struct rcu_torture_ops {
 	int irq_capable;
 	char *name;
 };
-static struct rcu_torture_ops *cur_ops = NULL;
+
+static struct rcu_torture_ops *cur_ops;
 
 /*
  * Definitions for rcu torture testing.
@@ -342,8 +343,8 @@ static struct rcu_torture_ops rcu_ops = {
 	.sync		= synchronize_rcu,
 	.cb_barrier	= rcu_barrier,
 	.stats		= NULL,
-	.irq_capable 	= 1,
-	.name 		= "rcu"
+	.irq_capable	= 1,
+	.name		= "rcu"
 };
 
 static void rcu_sync_torture_deferred_free(struct rcu_torture *p)
@@ -641,7 +642,8 @@ rcu_torture_writer(void *arg)
 
 	do {
 		schedule_timeout_uninterruptible(1);
-		if ((rp = rcu_torture_alloc()) == NULL)
+		rp = rcu_torture_alloc();
+		if (rp == NULL)
 			continue;
 		rp->rtort_pipe_count = 0;
 		udelay(rcu_random(&rand) & 0x3ff);
@@ -1113,7 +1115,7 @@ rcu_torture_init(void)
 		printk(KERN_ALERT "rcutorture: invalid torture type: \"%s\"\n",
 		       torture_type);
 		mutex_unlock(&fullstop_mutex);
-		return (-EINVAL);
+		return -EINVAL;
 	}
 	if (cur_ops->init)
 		cur_ops->init(); /* no "goto unwind" prior to this point!!! */
@@ -1164,7 +1166,7 @@ rcu_torture_init(void)
 		goto unwind;
 	}
 	fakewriter_tasks = kzalloc(nfakewriters * sizeof(fakewriter_tasks[0]),
-	                           GFP_KERNEL);
+				   GFP_KERNEL);
 	if (fakewriter_tasks == NULL) {
 		VERBOSE_PRINTK_ERRSTRING("out of memory");
 		firsterr = -ENOMEM;
@@ -1173,7 +1175,7 @@ rcu_torture_init(void)
 	for (i = 0; i < nfakewriters; i++) {
 		VERBOSE_PRINTK_STRING("Creating rcu_torture_fakewriter task");
 		fakewriter_tasks[i] = kthread_run(rcu_torture_fakewriter, NULL,
-		                                  "rcu_torture_fakewriter");
+						  "rcu_torture_fakewriter");
 		if (IS_ERR(fakewriter_tasks[i])) {
 			firsterr = PTR_ERR(fakewriter_tasks[i]);
 			VERBOSE_PRINTK_ERRSTRING("Failed to create fakewriter");
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 1b32cdd..52b06f6 100644
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
index 09b7325..1cee04f 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -370,9 +370,8 @@ static void rcu_preempt_check_callbacks(int cpu)
 		rcu_preempt_qs(cpu);
 		return;
 	}
-	if (per_cpu(rcu_preempt_data, cpu).qs_pending) {
+	if (per_cpu(rcu_preempt_data, cpu).qs_pending)
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
-	}
 }
 
 /*
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
