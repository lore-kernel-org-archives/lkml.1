Return-Path: <linux-kernel-owner+w=401wt.eu-S933821AbYCWI7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821AbYCWI7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757901AbYCWIMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:03 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2351 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758182AbYCWILq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:46 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 054/148] include/asm-x86/irq_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:29 -0700
Message-Id: <1206259443-13210-55-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/irq_64.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/irq_64.h b/include/asm-x86/irq_64.h
index 5006c6e..083d35a 100644
--- a/include/asm-x86/irq_64.h
+++ b/include/asm-x86/irq_64.h
@@ -31,10 +31,10 @@
 
 #define FIRST_SYSTEM_VECTOR	0xef   /* duplicated in hw_irq.h */
 
-#define NR_IRQS (NR_VECTORS + (32 *NR_CPUS))
+#define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))
 #define NR_IRQ_VECTORS NR_IRQS
 
-static __inline__ int irq_canonicalize(int irq)
+static inline int irq_canonicalize(int irq)
 {
 	return ((irq == 2) ? 9 : irq);
 }
-- 
1.5.4.rc2

