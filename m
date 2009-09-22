Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbZIVFaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbZIVFaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbZIVFaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:30:08 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46345 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbZIVFaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:30:07 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 1/5] futex: correct futex_wait_requeue_pi() commentary
To: linux-kernel@vger.kernel.org
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@us.ibm.com>
Date: Mon, 21 Sep 2009 22:29:59 -0700
Message-ID: <20090922052958.8717.21932.stgit@Aeon>
In-Reply-To: <20090922052452.8717.39673.stgit@Aeon>
References: <20090922052452.8717.39673.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct various typos and formatting inconsistencies in the commentary of
futex_wait_requeue_pi().

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Dinakar Guniguntala <dino@in.ibm.com>
CC: John Stultz <johnstul@us.ibm.com>
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

