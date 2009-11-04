Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbZKDLKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbZKDLKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755460AbZKDLKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:10:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:39737 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459AbZKDLKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:10:34 -0500
Date: Wed, 4 Nov 2009 11:10:12 GMT
From: tip-bot for Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, h-shimamoto@ct.jp.nec.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AF129C8.3030008@ct.jp.nec.com>
References: <4AF129C8.3030008@ct.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove unused __schedule() declaration
Message-ID: <tip-1477b6a7edd9ffa7bba4f9779ce9a76ce92761ed@git.kernel.org>
Git-Commit-ID: 1477b6a7edd9ffa7bba4f9779ce9a76ce92761ed
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1477b6a7edd9ffa7bba4f9779ce9a76ce92761ed
Gitweb:     http://git.kernel.org/tip/1477b6a7edd9ffa7bba4f9779ce9a76ce92761ed
Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
AuthorDate: Wed, 4 Nov 2009 16:14:16 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Nov 2009 11:43:42 +0100

sched: Remove unused __schedule() declaration

__schedule() had been removed.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4AF129C8.3030008@ct.jp.nec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    1 -
 kernel/kgdb.c         |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 75e6e60..f18102c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -349,7 +349,6 @@ extern signed long schedule_timeout(signed long timeout);
 extern signed long schedule_timeout_interruptible(signed long timeout);
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
-asmlinkage void __schedule(void);
 asmlinkage void schedule(void);
 extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner);
 
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 9147a31..7d70146 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -870,7 +870,7 @@ static void gdb_cmd_getregs(struct kgdb_state *ks)
 
 	/*
 	 * All threads that don't have debuggerinfo should be
-	 * in __schedule() sleeping, since all other CPUs
+	 * in schedule() sleeping, since all other CPUs
 	 * are in kgdb_wait, and thus have debuggerinfo.
 	 */
 	if (local_debuggerinfo) {
