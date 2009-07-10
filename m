Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbZGJRYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbZGJRYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 13:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbZGJRXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 13:23:53 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:55490 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbZGJRXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 13:23:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=d1SV79udXh4QE4ds8rNyNQIdbLWgcVrlyBkkveMIbS7kjCQ7SNEEAZDm+Wo4Fw5KSo
         F70JD8UpKrG3PwG/B4N6bUU+wVKxAaaZPj6pkDW0ZIk0zfT7yRicFSf9rMLqhZ83jy9R
         m6rwCG/N9y7sHbSdme5S+ixWK+pjvdkbrofd0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] sched: Remove obsolete comment in __cond_resched()
Date: Fri, 10 Jul 2009 19:23:45 +0200
Message-Id: <1247246625-5836-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090710161141.GC22049@elte.hu>
References: <20090710161141.GC22049@elte.hu>
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
index 649ec92..7b2ab88 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6605,11 +6605,6 @@ SYSCALL_DEFINE0(sched_yield)
 
 static void __cond_resched(void)
 {
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

