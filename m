Return-Path: <linux-kernel-owner+w=401wt.eu-S932914AbYCWIwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914AbYCWIwl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760120AbYCWILl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:41 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2338 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760103AbYCWILg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:36 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 004/148] include/asm-x86/apicdef.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:39 -0700
Message-Id: <1206259443-13210-5-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/apicdef.h |   50 ++++++++++++++++++++++----------------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/asm-x86/apicdef.h b/include/asm-x86/apicdef.h
index 674a228..8b24468 100644
--- a/include/asm-x86/apicdef.h
+++ b/include/asm-x86/apicdef.h
@@ -14,10 +14,10 @@
 
 #define	APIC_LVR	0x30
 #define		APIC_LVR_MASK		0xFF00FF
-#define		GET_APIC_VERSION(x)	((x)&0xFFu)
-#define		GET_APIC_MAXLVT(x)	(((x)>>16)&0xFFu)
+#define		GET_APIC_VERSION(x)	((x) & 0xFFu)
+#define		GET_APIC_MAXLVT(x)	(((x) >> 16) & 0xFFu)
 #ifdef CONFIG_X86_32
-#  define	APIC_INTEGRATED(x)	((x)&0xF0u)
+#  define	APIC_INTEGRATED(x)	((x) & 0xF0u)
 #else
 #  define	APIC_INTEGRATED(x)	(1)
 #endif
@@ -31,16 +31,16 @@
 #define		APIC_EIO_ACK		0x0
 #define	APIC_RRR	0xC0
 #define	APIC_LDR	0xD0
-#define		APIC_LDR_MASK		(0xFFu<<24)
-#define		GET_APIC_LOGICAL_ID(x)	(((x)>>24)&0xFFu)
-#define		SET_APIC_LOGICAL_ID(x)	(((x)<<24))
+#define		APIC_LDR_MASK		(0xFFu << 24)
+#define		GET_APIC_LOGICAL_ID(x)	(((x) >> 24) & 0xFFu)
+#define		SET_APIC_LOGICAL_ID(x)	(((x) << 24))
 #define		APIC_ALL_CPUS		0xFFu
 #define	APIC_DFR	0xE0
 #define		APIC_DFR_CLUSTER		0x0FFFFFFFul
 #define		APIC_DFR_FLAT			0xFFFFFFFFul
 #define	APIC_SPIV	0xF0
-#define		APIC_SPIV_FOCUS_DISABLED	(1<<9)
-#define		APIC_SPIV_APIC_ENABLED		(1<<8)
+#define		APIC_SPIV_FOCUS_DISABLED	(1 << 9)
+#define		APIC_SPIV_APIC_ENABLED		(1 << 8)
 #define	APIC_ISR	0x100
 #define	APIC_ISR_NR     0x8     /* Number of 32 bit ISR registers. */
 #define	APIC_TMR	0x180
@@ -76,27 +76,27 @@
 #define		APIC_DM_EXTINT		0x00700
 #define		APIC_VECTOR_MASK	0x000FF
 #define	APIC_ICR2	0x310
-#define		GET_APIC_DEST_FIELD(x)	(((x)>>24)&0xFF)
-#define		SET_APIC_DEST_FIELD(x)	((x)<<24)
+#define		GET_APIC_DEST_FIELD(x)	(((x) >> 24) & 0xFF)
+#define		SET_APIC_DEST_FIELD(x)	((x) << 24)
 #define	APIC_LVTT	0x320
 #define	APIC_LVTTHMR	0x330
 #define	APIC_LVTPC	0x340
 #define	APIC_LVT0	0x350
-#define		APIC_LVT_TIMER_BASE_MASK	(0x3<<18)
-#define		GET_APIC_TIMER_BASE(x)		(((x)>>18)&0x3)
-#define		SET_APIC_TIMER_BASE(x)		(((x)<<18))
+#define		APIC_LVT_TIMER_BASE_MASK	(0x3 << 18)
+#define		GET_APIC_TIMER_BASE(x)		(((x) >> 18) & 0x3)
+#define		SET_APIC_TIMER_BASE(x)		(((x) << 18))
 #define		APIC_TIMER_BASE_CLKIN		0x0
 #define		APIC_TIMER_BASE_TMBASE		0x1
 #define		APIC_TIMER_BASE_DIV		0x2
-#define		APIC_LVT_TIMER_PERIODIC		(1<<17)
-#define		APIC_LVT_MASKED			(1<<16)
-#define		APIC_LVT_LEVEL_TRIGGER		(1<<15)
-#define		APIC_LVT_REMOTE_IRR		(1<<14)
-#define		APIC_INPUT_POLARITY		(1<<13)
-#define		APIC_SEND_PENDING		(1<<12)
+#define		APIC_LVT_TIMER_PERIODIC		(1 << 17)
+#define		APIC_LVT_MASKED			(1 << 16)
+#define		APIC_LVT_LEVEL_TRIGGER		(1 << 15)
+#define		APIC_LVT_REMOTE_IRR		(1 << 14)
+#define		APIC_INPUT_POLARITY		(1 << 13)
+#define		APIC_SEND_PENDING		(1 << 12)
 #define		APIC_MODE_MASK			0x700
-#define		GET_APIC_DELIVERY_MODE(x)	(((x)>>8)&0x7)
-#define		SET_APIC_DELIVERY_MODE(x, y)	(((x)&~0x700)|((y)<<8))
+#define		GET_APIC_DELIVERY_MODE(x)	(((x) >> 8) & 0x7)
+#define		SET_APIC_DELIVERY_MODE(x, y)	(((x) & ~0x700) | ((y) << 8))
 #define			APIC_MODE_FIXED		0x0
 #define			APIC_MODE_NMI		0x4
 #define			APIC_MODE_EXTINT	0x7
@@ -105,7 +105,7 @@
 #define	APIC_TMICT	0x380
 #define	APIC_TMCCT	0x390
 #define	APIC_TDCR	0x3E0
-#define		APIC_TDR_DIV_TMBASE	(1<<2)
+#define		APIC_TDR_DIV_TMBASE	(1 << 2)
 #define		APIC_TDR_DIV_1		0xB
 #define		APIC_TDR_DIV_2		0x0
 #define		APIC_TDR_DIV_4		0x1
@@ -115,14 +115,14 @@
 #define		APIC_TDR_DIV_64		0x9
 #define		APIC_TDR_DIV_128	0xA
 #define	APIC_EILVT0     0x500
-#define		APIC_EILVT_NR_AMD_K8	1	/* Number of extended interrupts */
+#define		APIC_EILVT_NR_AMD_K8	1	/* # of extended interrupts */
 #define		APIC_EILVT_NR_AMD_10H	4
-#define		APIC_EILVT_LVTOFF(x)	(((x)>>4)&0xF)
+#define		APIC_EILVT_LVTOFF(x)	(((x) >> 4) & 0xF)
 #define		APIC_EILVT_MSG_FIX	0x0
 #define		APIC_EILVT_MSG_SMI	0x2
 #define		APIC_EILVT_MSG_NMI	0x4
 #define		APIC_EILVT_MSG_EXT	0x7
-#define		APIC_EILVT_MASKED	(1<<16)
+#define		APIC_EILVT_MASKED	(1 << 16)
 #define	APIC_EILVT1     0x510
 #define	APIC_EILVT2     0x520
 #define	APIC_EILVT3     0x530
-- 
1.5.4.rc2

