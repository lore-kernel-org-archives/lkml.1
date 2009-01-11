Return-Path: <linux-kernel-owner+w=401wt.eu-S1751827AbZAKJFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbZAKJFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 04:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZAKJEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 04:04:32 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:24923 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbZAKJE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 04:04:29 -0500
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Steven Noonan <steven@uplinklabs.net>
Subject: [PATCH -tip 2/2] kernel/sched.c: forward declaration for 'double_rq_lock' missing
Date: Sun, 11 Jan 2009 01:04:22 -0800
Message-Id: <1231664662-17104-2-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1231664662-17104-1-git-send-email-steven@uplinklabs.net>
References: <1231664662-17104-1-git-send-email-steven@uplinklabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: compile error eliminated

Added 'double_rq_lock' forward declaration, allowing double_rq_lock
to be used in _double_lock_balance().

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 kernel/sched.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8409dba..107c5a2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -125,6 +125,9 @@ DEFINE_TRACE(sched_switch);
 DEFINE_TRACE(sched_migrate_task);
 
 #ifdef CONFIG_SMP
+
+static void double_rq_lock(struct rq *rq1, struct rq *rq2);
+
 /*
  * Divide a load by a sched group cpu_power : (load / sg->__cpu_power)
  * Since cpu_power is a 'constant', we can use a reciprocal divide.
-- 
1.6.1

