Return-Path: <linux-kernel-owner+w=401wt.eu-S1757493AbZGPG3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbZGPG3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 02:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZGPG3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 02:29:18 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:59564 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZGPG2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 02:28:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HRGM319uX2L+zIcc7Z3I3IiK58cP47LbJ505uwC8oAWi+KEA5qlzalv+DhyafGc43E
         2Ztz30bYH3JeQX/KucD0WjcheWHgV6LpXcbp9+tnjXh+qCvXE5KPEOlUDUyiGvjtvGjt
         BoMaJVp6TxwJtBOJfn862ASRc6sA56NnOLYLA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/7] sched: Remove obsolete comment in __cond_resched()
Date: Thu, 16 Jul 2009 02:28:09 -0400
Message-Id: <1247725694-6082-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1247725694-6082-1-git-send-email-fweisbec@gmail.com>
References: <1247725694-6082-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the outdated comment from __cond_resched() related
to the now removed Big Kernel Semaphore.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 264b163..bb11547 100644
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
-- 
1.6.2.3

