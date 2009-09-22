Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbZIVIli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbZIVIli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbZIVIlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:41:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:42308 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbZIVIlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:41:35 -0400
Date: Tue, 22 Sep 2009 08:41:00 GMT
From: tip-bot for Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, eric.dumazet@gmail.com, johnstul@us.ibm.com,
       peterz@infradead.org, dino@in.ibm.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       johnstul@us.ibm.com, peterz@infradead.org, dino@in.ibm.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090922053022.8717.13339.stgit@Aeon>
References: <20090922053022.8717.13339.stgit@Aeon>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futex: Make function kernel-doc commentary consistent
Message-ID: <tip-d96ee56ce0582967fba9f3f0ac4503957147bea6@git.kernel.org>
Git-Commit-ID: d96ee56ce0582967fba9f3f0ac4503957147bea6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 08:41:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d96ee56ce0582967fba9f3f0ac4503957147bea6
Gitweb:     http://git.kernel.org/tip/d96ee56ce0582967fba9f3f0ac4503957147bea6
Author:     Darren Hart <dvhltc@us.ibm.com>
AuthorDate: Mon, 21 Sep 2009 22:30:22 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 22 Sep 2009 10:37:43 +0200

futex: Make function kernel-doc commentary consistent

Make the existing function kernel-doc consistent throughout
futex.c, following Documentation/kernel-doc-nano-howto.txt as
closely as possible.

When unsure, at least be consistent within futex.c.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <20090922053022.8717.13339.stgit@Aeon>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/futex.c |   41 +++++++++++++++++++++--------------------
 1 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index cedcd60..720fa3d 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -198,11 +198,12 @@ static void drop_futex_key_refs(union futex_key *key)
 }
 
 /**
- * get_futex_key - Get parameters which are the keys for a futex.
- * @uaddr: virtual address of the futex
- * @fshared: 0 for a PROCESS_PRIVATE futex, 1 for PROCESS_SHARED
- * @key: address where result is stored.
- * @rw: mapping needs to be read/write (values: VERIFY_READ, VERIFY_WRITE)
+ * get_futex_key() - Get parameters which are the keys for a futex
+ * @uaddr:	virtual address of the futex
+ * @fshared:	0 for a PROCESS_PRIVATE futex, 1 for PROCESS_SHARED
+ * @key:	address where result is stored.
+ * @rw:		mapping needs to be read/write (values: VERIFY_READ,
+ * 		VERIFY_WRITE)
  *
  * Returns a negative error code or 0
  * The key words are stored in *key on success.
@@ -288,8 +289,8 @@ void put_futex_key(int fshared, union futex_key *key)
 	drop_futex_key_refs(key);
 }
 
-/*
- * fault_in_user_writeable - fault in user address and verify RW access
+/**
+ * fault_in_user_writeable() - Fault in user address and verify RW access
  * @uaddr:	pointer to faulting user space address
  *
  * Slow path to fixup the fault we just took in the atomic write
@@ -309,8 +310,8 @@ static int fault_in_user_writeable(u32 __user *uaddr)
 
 /**
  * futex_top_waiter() - Return the highest priority waiter on a futex
- * @hb:     the hash bucket the futex_q's reside in
- * @key:    the futex key (to distinguish it from other futex futex_q's)
+ * @hb:		the hash bucket the futex_q's reside in
+ * @key:	the futex key (to distinguish it from other futex futex_q's)
  *
  * Must be called with the hb lock held.
  */
@@ -588,7 +589,7 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 }
 
 /**
- * futex_lock_pi_atomic() - atomic work required to acquire a pi aware futex
+ * futex_lock_pi_atomic() - Atomic work required to acquire a pi aware futex
  * @uaddr:		the pi futex user address
  * @hb:			the pi futex hash bucket
  * @key:		the futex key associated with uaddr and hb
@@ -1011,9 +1012,9 @@ void requeue_futex(struct futex_q *q, struct futex_hash_bucket *hb1,
 
 /**
  * requeue_pi_wake_futex() - Wake a task that acquired the lock during requeue
- * q:	the futex_q
- * key:	the key of the requeue target futex
- * hb:  the hash_bucket of the requeue target futex
+ * @q:		the futex_q
+ * @key:	the key of the requeue target futex
+ * @hb:		the hash_bucket of the requeue target futex
  *
  * During futex_requeue, with requeue_pi=1, it is possible to acquire the
  * target futex if it is uncontended or via a lock steal.  Set the futex_q key
@@ -2319,9 +2320,9 @@ out:
  */
 
 /**
- * sys_set_robust_list - set the robust-futex list head of a task
- * @head: pointer to the list-head
- * @len: length of the list-head, as userspace expects
+ * sys_set_robust_list() - Set the robust-futex list head of a task
+ * @head:	pointer to the list-head
+ * @len:	length of the list-head, as userspace expects
  */
 SYSCALL_DEFINE2(set_robust_list, struct robust_list_head __user *, head,
 		size_t, len)
@@ -2340,10 +2341,10 @@ SYSCALL_DEFINE2(set_robust_list, struct robust_list_head __user *, head,
 }
 
 /**
- * sys_get_robust_list - get the robust-futex list head of a task
- * @pid: pid of the process [zero for current task]
- * @head_ptr: pointer to a list-head pointer, the kernel fills it in
- * @len_ptr: pointer to a length field, the kernel fills in the header size
+ * sys_get_robust_list() - Get the robust-futex list head of a task
+ * @pid:	pid of the process [zero for current task]
+ * @head_ptr:	pointer to a list-head pointer, the kernel fills it in
+ * @len_ptr:	pointer to a length field, the kernel fills in the header size
  */
 SYSCALL_DEFINE3(get_robust_list, int, pid,
 		struct robust_list_head __user * __user *, head_ptr,
