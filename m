Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab0BHGTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 01:19:52 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:48699 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab0BHGTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 01:19:51 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: linux-kernel@vger.kernel.org
Cc: Baruch Siach <baruch@tkos.co.il>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] sched: fix unused variable warning when !CONFIG_SMP
Date: Mon,  8 Feb 2010 08:18:52 +0200
Message-Id: <de61b5c64f7809ea210c6b4bb3dc3061efe4429c.1265609796.git.baruch@tkos.co.il>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This variable was introduced by fabf318e.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3a8fb30..c9d9dff 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2647,9 +2647,9 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 {
 	unsigned long flags;
 	struct rq *rq;
+#ifdef CONFIG_SMP
 	int cpu = get_cpu();
 
-#ifdef CONFIG_SMP
 	/*
 	 * Fork balancing, do it here and not earlier because:
 	 *  - cpus_allowed can change in the fork path
-- 
1.6.5

