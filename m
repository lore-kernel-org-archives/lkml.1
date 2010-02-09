Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0BIKxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 05:53:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:41706 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923Ab0BIKxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 05:53:03 -0500
Date: Tue, 9 Feb 2010 10:52:16 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100209040740.GB3702@kryten>
References: <20100209040740.GB3702@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] kthread, sched: Remove reference to kthread_create_on_cpu
Message-ID: <tip-301ba0457f1ed853fc08e57785f8c87fe7e49c68@git.kernel.org>
Git-Commit-ID: 301ba0457f1ed853fc08e57785f8c87fe7e49c68
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Feb 2010 10:52:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  301ba0457f1ed853fc08e57785f8c87fe7e49c68
Gitweb:     http://git.kernel.org/tip/301ba0457f1ed853fc08e57785f8c87fe7e49c68
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Tue, 9 Feb 2010 15:07:40 +1100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 9 Feb 2010 11:47:39 +0100

kthread, sched: Remove reference to kthread_create_on_cpu

kthread_create_on_cpu doesn't exist so update a comment in
kthread.c to reflect this.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100209040740.GB3702@kryten>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/kthread.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index fbb6222..82ed0ea 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -101,7 +101,7 @@ static void create_kthread(struct kthread_create_info *create)
  *
  * Description: This helper function creates and names a kernel
  * thread.  The thread will be stopped: use wake_up_process() to start
- * it.  See also kthread_run(), kthread_create_on_cpu().
+ * it.  See also kthread_run().
  *
  * When woken, the thread will run @threadfn() with @data as its
  * argument. @threadfn() can either call do_exit() directly if it is a
