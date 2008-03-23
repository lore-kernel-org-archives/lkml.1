Return-Path: <linux-kernel-owner+w=401wt.eu-S1765041AbYCWIky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765041AbYCWIky (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759877AbYCWIKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:35 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2308 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759854AbYCWIKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:33 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 042/148] include/asm-x86/hypertransport.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:17 -0700
Message-Id: <1206259443-13210-43-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/hypertransport.h |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/asm-x86/hypertransport.h b/include/asm-x86/hypertransport.h
index c16c6ff..d2bbd23 100644
--- a/include/asm-x86/hypertransport.h
+++ b/include/asm-x86/hypertransport.h
@@ -8,12 +8,14 @@
 #define HT_IRQ_LOW_BASE			0xf8000000
 
 #define HT_IRQ_LOW_VECTOR_SHIFT		16
-#define  HT_IRQ_LOW_VECTOR_MASK		0x00ff0000
-#define  HT_IRQ_LOW_VECTOR(v)		(((v) << HT_IRQ_LOW_VECTOR_SHIFT) & HT_IRQ_LOW_VECTOR_MASK)
+#define HT_IRQ_LOW_VECTOR_MASK		0x00ff0000
+#define HT_IRQ_LOW_VECTOR(v)						\
+	(((v) << HT_IRQ_LOW_VECTOR_SHIFT) & HT_IRQ_LOW_VECTOR_MASK)
 
 #define HT_IRQ_LOW_DEST_ID_SHIFT	8
-#define  HT_IRQ_LOW_DEST_ID_MASK	0x0000ff00
-#define  HT_IRQ_LOW_DEST_ID(v)		(((v) << HT_IRQ_LOW_DEST_ID_SHIFT) & HT_IRQ_LOW_DEST_ID_MASK)
+#define HT_IRQ_LOW_DEST_ID_MASK		0x0000ff00
+#define HT_IRQ_LOW_DEST_ID(v)						\
+	(((v) << HT_IRQ_LOW_DEST_ID_SHIFT) & HT_IRQ_LOW_DEST_ID_MASK)
 
 #define HT_IRQ_LOW_DM_PHYSICAL		0x0000000
 #define HT_IRQ_LOW_DM_LOGICAL		0x0000040
@@ -36,7 +38,8 @@
 
 
 #define HT_IRQ_HIGH_DEST_ID_SHIFT	0
-#define  HT_IRQ_HIGH_DEST_ID_MASK	0x00ffffff
-#define  HT_IRQ_HIGH_DEST_ID(v)		((((v) >> 8) << HT_IRQ_HIGH_DEST_ID_SHIFT) & HT_IRQ_HIGH_DEST_ID_MASK)
+#define HT_IRQ_HIGH_DEST_ID_MASK	0x00ffffff
+#define HT_IRQ_HIGH_DEST_ID(v)						\
+	((((v) >> 8) << HT_IRQ_HIGH_DEST_ID_SHIFT) & HT_IRQ_HIGH_DEST_ID_MASK)
 
 #endif /* ASM_HYPERTRANSPORT_H */
-- 
1.5.4.rc2

