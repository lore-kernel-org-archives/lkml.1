Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZIVIlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZIVIlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbZIVIlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:41:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:42266 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452AbZIVIlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:41:05 -0400
Date: Tue, 22 Sep 2009 08:40:33 GMT
From: tip-bot for Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, eric.dumazet@gmail.com, johnstul@us.ibm.com,
       peterz@infradead.org, dino@in.ibm.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       johnstul@us.ibm.com, peterz@infradead.org, dino@in.ibm.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090922052958.8717.21932.stgit@Aeon>
References: <20090922052958.8717.21932.stgit@Aeon>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futex: Correct futex_wait_requeue_pi() commentary
Message-ID: <tip-56ec1607b15b6a5f6de5aab14f16a763b88296fc@git.kernel.org>
Git-Commit-ID: 56ec1607b15b6a5f6de5aab14f16a763b88296fc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 08:40:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56ec1607b15b6a5f6de5aab14f16a763b88296fc
Gitweb:     http://git.kernel.org/tip/56ec1607b15b6a5f6de5aab14f16a763b88296fc
Author:     Darren Hart <dvhltc@us.ibm.com>
AuthorDate: Mon, 21 Sep 2009 22:29:59 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 22 Sep 2009 10:37:42 +0200

futex: Correct futex_wait_requeue_pi() commentary

Correct various typos and formatting inconsistencies in the
commentary of futex_wait_requeue_pi().

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <20090922052958.8717.21932.stgit@Aeon>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/futex.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 248dd11..6c498b1 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2114,12 +2114,12 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 
 /**
  * futex_wait_requeue_pi() - Wait on uaddr and take uaddr2
- * @uaddr:	the futex we initialyl wait on (non-pi)
+ * @uaddr:	the futex we initially wait on (non-pi)
  * @fshared:	whether the futexes are shared (1) or not (0).  They must be
  * 		the same type, no requeueing from private to shared, etc.
  * @val:	the expected value of uaddr
  * @abs_time:	absolute timeout
- * @bitset:	32 bit wakeup bitset set by userspace, defaults to all.
+ * @bitset:	32 bit wakeup bitset set by userspace, defaults to all
  * @clockrt:	whether to use CLOCK_REALTIME (1) or CLOCK_MONOTONIC (0)
  * @uaddr2:	the pi futex we will take prior to returning to user-space
  *
@@ -2246,7 +2246,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 		res = fixup_owner(uaddr2, fshared, &q, !ret);
 		/*
 		 * If fixup_owner() returned an error, proprogate that.  If it
-		 * acquired the lock, clear our -ETIMEDOUT or -EINTR.
+		 * acquired the lock, clear -ETIMEDOUT or -EINTR.
 		 */
 		if (res)
 			ret = (res < 0) ? res : 0;
