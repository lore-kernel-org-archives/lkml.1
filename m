Return-Path: <linux-kernel-owner+w=401wt.eu-S1752576AbZGROWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbZGROWb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 10:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbZGROW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 10:22:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:53899 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbZGROW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 10:22:27 -0400
Date: Sat, 18 Jul 2009 14:21:45 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, arnd@arndb.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: arnd@arndb.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1247725694-6082-2-git-send-email-fweisbec@gmail.com>
References: <1247725694-6082-2-git-send-email-fweisbec@gmail.com>
Subject: [tip:sched/core] sched: Remove obsolete comment in __cond_resched()
Message-ID: <tip-4b2155678d7cc7b5f45d6b36049091376c3408a2@git.kernel.org>
Git-Commit-ID: 4b2155678d7cc7b5f45d6b36049091376c3408a2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 14:21:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b2155678d7cc7b5f45d6b36049091376c3408a2
Gitweb:     http://git.kernel.org/tip/4b2155678d7cc7b5f45d6b36049091376c3408a2
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 15:51:39 +0200

sched: Remove obsolete comment in __cond_resched()

Remove the outdated comment from __cond_resched() related to
the now removed Big Kernel Semaphore.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1247725694-6082-2-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 4c5ee84..4d39e96 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6613,11 +6613,6 @@ static void __cond_resched(void)
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
 	__might_sleep(__FILE__, __LINE__);
 #endif
-	/*
-	 * The BKS might be reacquired before we have dropped
-	 * PREEMPT_ACTIVE, which could trigger a second
-	 * cond_resched() call.
-	 */
 	add_preempt_count(PREEMPT_ACTIVE);
 	schedule();
 	sub_preempt_count(PREEMPT_ACTIVE);
