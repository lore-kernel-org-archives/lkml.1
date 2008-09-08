Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbYIHA7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbYIHA7d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 20:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYIHA7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 20:59:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:51963 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbYIHA7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 20:59:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QzjjnJedkvwZAVdyEpcCQ26Hki7eHzMCW7PXZxgFxV8i9PCD9fJo4HnyvvVimvkKSc
         4kV45e4jsJdWNrypWVg4nL8QL6o5647EGFx47Bp/u1t6eBxdUh45cnOlWX5kek16HIP9
         Apj0dJXwffIklnaEnySmPrGjT9zSpT6wUNNS0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 2/9] x86: remove duplicated force_mwait
Date: Sun,  7 Sep 2008 17:58:51 -0700
Message-Id: <1220835538-18280-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220835538-18280-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220835538-18280-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/amd_64.c |    2 --
 arch/x86/kernel/process.c    |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd_64.c b/arch/x86/kernel/cpu/amd_64.c
index 7913e48..466a1ea 100644
--- a/arch/x86/kernel/cpu/amd_64.c
+++ b/arch/x86/kernel/cpu/amd_64.c
@@ -9,8 +9,6 @@
 
 #include "cpu.h"
 
-int force_mwait __cpuinitdata;
-
 #ifdef CONFIG_NUMA
 static int __cpuinit nearby_node(int apicid)
 {
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index bb91cdf..b191c31 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -15,7 +15,6 @@ unsigned long idle_nomwait;
 EXPORT_SYMBOL(idle_nomwait);
 
 struct kmem_cache *task_xstate_cachep;
-static int force_mwait __cpuinitdata;
 
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
-- 
1.5.4.5

