Return-Path: <linux-kernel-owner+w=401wt.eu-S1763300AbYCWIYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763300AbYCWIYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759392AbYCWIJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:16 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2274 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759373AbYCWIJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:15 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 080/148] include/asm-x86/numa_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:55 -0700
Message-Id: <1206259443-13210-81-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/numa_64.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/numa_64.h b/include/asm-x86/numa_64.h
index 15fe07c..32c22ae 100644
--- a/include/asm-x86/numa_64.h
+++ b/include/asm-x86/numa_64.h
@@ -1,11 +1,12 @@
-#ifndef _ASM_X8664_NUMA_H 
+#ifndef _ASM_X8664_NUMA_H
 #define _ASM_X8664_NUMA_H 1
 
 #include <linux/nodemask.h>
 #include <asm/apicdef.h>
 
 struct bootnode {
-	u64 start,end; 
+	u64 start;
+	u64 end;
 };
 
 extern int compute_hash_shift(struct bootnode *nodes, int numnodes);
-- 
1.5.4.rc2

