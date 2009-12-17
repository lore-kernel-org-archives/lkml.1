Return-Path: <linux-kernel-owner+w=401wt.eu-S1751256AbZLQFKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256AbZLQFKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 00:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbZLQFKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 00:10:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:50518 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbZLQFKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 00:10:34 -0500
Date: Thu, 17 Dec 2009 05:09:36 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091216170517.807938893@chello.nl>
References: <20091216170517.807938893@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Make warning less noisy
Message-ID: <tip-416eb39556a03d1c7e52b0791e9052ccd71db241@git.kernel.org>
Git-Commit-ID: 416eb39556a03d1c7e52b0791e9052ccd71db241
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  416eb39556a03d1c7e52b0791e9052ccd71db241
Gitweb:     http://git.kernel.org/tip/416eb39556a03d1c7e52b0791e9052ccd71db241
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 17 Dec 2009 06:05:49 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Dec 2009 06:05:49 +0100

sched: Make warning less noisy

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091216170517.807938893@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8a2bfd3..af7dfa7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2041,7 +2041,7 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 	 * We should never call set_task_cpu() on a blocked task,
 	 * ttwu() will sort out the placement.
 	 */
-	WARN_ON(p->state != TASK_RUNNING && p->state != TASK_WAKING);
+	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING);
 #endif
 
 	trace_sched_migrate_task(p, new_cpu);
