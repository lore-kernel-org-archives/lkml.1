Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbZCKWAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbZCKWAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbZCKV6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:58:16 -0400
Received: from smtp107.biz.mail.mud.yahoo.com ([68.142.200.255]:41001 "HELO
	smtp107.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754310AbZCKV6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:58:13 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: S2e6AUQVM1nvDbTeTYd2kLABP7oQqPNauJL_GClm9oHZXlRHiyGtd9tP5FW_bdB.ll0eOV3XxBxE8VtECaWjH8Gj5EzQN9vIIn5LkRgdSCS_pEEbxq0qMUGQqYPb7h21V1Cbkvaaeeu92PsxtyH8LG1FIL_Dy4CwXIc3HhkowsKnqiRNthgaOT2kBzgnKolE6A70hbElx3n7MpQRFhHaHxpd5190wiJZKzoyoPOs9HiZZDw-
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
To: uClinux development list <uclinux-dev@uclinux.org>
Subject: [RFC 08/14] Coldfire generic GPIO (m68knommu)
Date: Wed, 11 Mar 2009 13:56:01 -0800
User-Agent: KMail/1.9.10
Organization: fdwdc.com
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@snapgear.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200903111456.01772.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Steven King <sfking@fdwdc.com>

diff --git a/arch/m68k/include/asm/m5272sim.h b/arch/m68k/include/asm/m5272sim.h
index 6217edc..0665ba1 100644
--- a/arch/m68k/include/asm/m5272sim.h
+++ b/arch/m68k/include/asm/m5272sim.h
@@ -63,16 +63,22 @@
 #define	MCFSIM_DCMR1		0x5c		/* DRAM 1 Mask reg (r/w) */
 #define	MCFSIM_DCCR1		0x63		/* DRAM 1 Control reg (r/w) */
 
-#define	MCFSIM_PACNT		0x80		/* Port A Control (r/w) */
-#define	MCFSIM_PADDR		0x84		/* Port A Direction (r/w) */
-#define	MCFSIM_PADAT		0x86		/* Port A Data (r/w) */
-#define	MCFSIM_PBCNT		0x88		/* Port B Control (r/w) */
-#define	MCFSIM_PBDDR		0x8c		/* Port B Direction (r/w) */
-#define	MCFSIM_PBDAT		0x8e		/* Port B Data (r/w) */
-#define	MCFSIM_PCDDR		0x94		/* Port C Direction (r/w) */
-#define	MCFSIM_PCDAT		0x96		/* Port C Data (r/w) */
-#define	MCFSIM_PDCNT		0x98		/* Port D Control (r/w) */
+#define	MCFSIM_PACNT		(MCF_MBAR + 0x80) /* Port A Control (r/w) */
+#define	MCFSIM_PADDR		(MCF_MBAR + 0x84) /* Port A Direction (r/w) */
+#define	MCFSIM_PADAT		(MCF_MBAR + 0x86) /* Port A Data (r/w) */
+#define	MCFSIM_PBCNT		(MCF_MBAR + 0x88) /* Port B Control (r/w) */
+#define	MCFSIM_PBDDR		(MCF_MBAR + 0x8c) /* Port B Direction (r/w) */
+#define	MCFSIM_PBDAT		(MCF_MBAR + 0x8e) /* Port B Data (r/w) */
+#define	MCFSIM_PCDDR		(MCF_MBAR + 0x94) /* Port C Direction (r/w) */
+#define	MCFSIM_PCDAT		(MCF_MBAR + 0x96) /* Port C Data (r/w) */
+#define	MCFSIM_PDCNT		(MCF_MBAR + 0x98) /* Port D Control (r/w) */
 
 
+/*
+ * Generic GPIO support
+ */
+#define MCFGPIO_PIN_MAX			48
+#define MCFGPIO_IRQ_MAX			-1
+#define MCFGPIO_IRQ_VECBASE		-1
 /****************************************************************************/
 #endif	/* m5272sim_h */
