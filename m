Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbZHZGdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbZHZGdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbZHZGdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:33:23 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:40447
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752073AbZHZGdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:33:22 -0400
Subject: Subject: [PATCH 16/33] score: create head files current.h device.h
	percpu.h scatterlist.h scoreregs.h
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:22:12 +0800
Message-Id: <1251267732.3073.24.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 061d1ba92a24a087783607f4234cb4dcd858c808 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:05:04 +0800
Subject: [PATCH 16/33] score: create head files current.h device.h percpu.h scatterlist.h scoreregs.h


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/current.h     |    6 ++++
 arch/score/include/asm/device.h      |    6 ++++
 arch/score/include/asm/percpu.h      |    6 ++++
 arch/score/include/asm/scatterlist.h |    6 ++++
 arch/score/include/asm/scoreregs.h   |   51 ++++++++++++++++++++++++++++++++++
 5 files changed, 75 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/current.h
 create mode 100644 arch/score/include/asm/device.h
 create mode 100644 arch/score/include/asm/percpu.h
 create mode 100644 arch/score/include/asm/scatterlist.h
 create mode 100644 arch/score/include/asm/scoreregs.h

diff --git a/arch/score/include/asm/current.h b/arch/score/include/asm/current.h
new file mode 100644
index 0000000..16eae9c
--- /dev/null
+++ b/arch/score/include/asm/current.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_CURRENT_H
+#define _ASM_SCORE_CURRENT_H
+
+#include <asm-generic/current.h>
+
+#endif /* _ASM_SCORE_CURRENT_H */
diff --git a/arch/score/include/asm/device.h b/arch/score/include/asm/device.h
new file mode 100644
index 0000000..2dc7cc5
--- /dev/null
+++ b/arch/score/include/asm/device.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_DEVICE_H
+#define _ASM_SCORE_DEVICE_H
+
+#include <asm-generic/device.h>
+
+#endif /* _ASM_SCORE_DEVICE_H */
diff --git a/arch/score/include/asm/percpu.h b/arch/score/include/asm/percpu.h
new file mode 100644
index 0000000..e7bd4e0
--- /dev/null
+++ b/arch/score/include/asm/percpu.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_PERCPU_H
+#define _ASM_SCORE_PERCPU_H
+
+#include <asm-generic/percpu.h>
+
+#endif /* _ASM_SCORE_PERCPU_H */
diff --git a/arch/score/include/asm/scatterlist.h b/arch/score/include/asm/scatterlist.h
new file mode 100644
index 0000000..9f533b8
--- /dev/null
+++ b/arch/score/include/asm/scatterlist.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_SCATTERLIST_H
+#define _ASM_SCORE_SCATTERLIST_H
+
+#include <asm-generic/scatterlist.h>
+
+#endif /* _ASM_SCORE_SCATTERLIST_H */
diff --git a/arch/score/include/asm/scoreregs.h b/arch/score/include/asm/scoreregs.h
new file mode 100644
index 0000000..d0ad292
--- /dev/null
+++ b/arch/score/include/asm/scoreregs.h
@@ -0,0 +1,51 @@
+#ifndef _ASM_SCORE_SCOREREGS_H
+#define _ASM_SCORE_SCOREREGS_H
+
+#include <linux/linkage.h>
+
+/* TIMER register */
+#define TIME0BASE		0x96080000
+#define P_TIMER0_CTRL		(TIME0BASE + 0x00)
+#define P_TIMER0_CPP_CTRL	(TIME0BASE + 0x04)
+#define P_TIMER0_PRELOAD	(TIME0BASE + 0x08)
+#define P_TIMER0_CPP_REG	(TIME0BASE + 0x0C)
+#define P_TIMER0_UPCNT		(TIME0BASE + 0x10)
+
+/* Timer Controller Register */
+/* bit 0 Timer enable */
+#define TMR_DISABLE	0x0000
+#define TMR_ENABLE	0x0001
+
+/* bit 1 Interrupt enable */
+#define TMR_IE_DISABLE	0x0000
+#define TMR_IE_ENABLE	0x0002
+
+/* bit 2 Output enable */
+#define TMR_OE_DISABLE	0x0004
+#define TMR_OE_ENABLE	0x0000
+
+/* bit4 Up/Down counting selection */
+#define TMR_UD_DOWN	0x0000
+#define TMR_UD_UP	0x0010
+
+/* bit5 Up/Down counting control selection */
+#define TMR_UDS_UD	0x0000
+#define TMR_UDS_EXTUD	0x0020
+
+/* bit6 Time output mode */
+#define TMR_OM_TOGGLE	0x0000
+#define TMR_OM_PILSE	0x0040
+
+/* bit 8..9 External input active edge selection */
+#define TMR_ES_PE	0x0000
+#define TMR_ES_NE	0x0100
+#define TMR_ES_BOTH	0x0200
+
+/* bit 10..11 Operating mode */
+#define TMR_M_FREE	0x0000 /* free running timer mode */
+#define TMR_M_PERIODIC	0x0400 /* periodic timer mode */
+#define TMR_M_FC	0x0800 /* free running counter mode */
+#define TMR_M_PC	0x0c00 /* periodic counter mode */
+
+#define SYSTEM_CLOCK		(27*1000000/4)		/* 27 MHz */
+#endif /* _ASM_SCORE_SCOREREGS_H */
-- 
1.6.2



