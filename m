Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbZFIGdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbZFIGdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbZFIGdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:33:47 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:36729 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbZFIGdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:33:46 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: [PATCH 09/27] score: create head files hardirq.h hw_irq.h
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFE06CA763.2ED1275C-ON482575D0.00237A09-482575D0.0023EB63@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 9 Jun 2009 14:28:02 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/09 ?? 02:28:03,
	Serialize complete at 2009/06/09 ?? 02:28:03
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 51b773886b5e793289490363af6bc8227f1fce0c Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Tue, 9 Jun 2009 13:43:09 +0800



Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/hardirq.h |   16 ++++++++++++++++
 arch/score/include/asm/hw_irq.h  |    4 ++++
 2 files changed, 20 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/hardirq.h
 create mode 100644 arch/score/include/asm/hw_irq.h

diff --git a/arch/score/include/asm/hardirq.h 
b/arch/score/include/asm/hardirq.h
new file mode 100644
index 0000000..c8345f5
--- /dev/null
+++ b/arch/score/include/asm/hardirq.h
@@ -0,0 +1,16 @@
+#ifndef _ASM_SCORE_HARDIRQ_H
+#define _ASM_SCORE_HARDIRQ_H
+
+#include <linux/threads.h>
+#include <linux/irq.h>
+
+typedef struct {
+       unsigned int __softirq_pending;
+} ____cacheline_aligned irq_cpustat_t;
+
+/* Standard mappings for irq_cpustat_t above */
+#include <linux/irq_cpustat.h>
+
+extern void ack_bad_irq(unsigned int irq);
+
+#endif /* _ASM_SCORE_HARDIRQ_H */
diff --git a/arch/score/include/asm/hw_irq.h 
b/arch/score/include/asm/hw_irq.h
new file mode 100644
index 0000000..4caafb2
--- /dev/null
+++ b/arch/score/include/asm/hw_irq.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_SCORE_HW_IRQ_H
+#define _ASM_SCORE_HW_IRQ_H
+
+#endif /* _ASM_SCORE_HW_IRQ_H */
-- 
1.6.2

