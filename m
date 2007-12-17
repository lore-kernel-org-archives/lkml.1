Return-Path: <linux-kernel-owner+w=401wt.eu-S933796AbXLQTi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933796AbXLQTi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761092AbXLQTbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:43 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2959 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760858AbXLQTbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:37 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Subject: [PATCH] include/asm-ppc/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:15 -0800
Message-Id: <1197919875-5288-16-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-ppc/8xx_immap.h |    2 +-
 include/asm-ppc/commproc.h  |    2 +-
 include/asm-ppc/reg_booke.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-ppc/8xx_immap.h b/include/asm-ppc/8xx_immap.h
index 1311cef..4b0e152 100644
--- a/include/asm-ppc/8xx_immap.h
+++ b/include/asm-ppc/8xx_immap.h
@@ -123,7 +123,7 @@ typedef struct	mem_ctlr {
 #define OR_G5LA		0x00000400	/* Output #GPL5 on #GPL_A5		*/
 #define OR_G5LS		0x00000200	/* Drive #GPL high on falling edge of...*/
 #define OR_BI		0x00000100	/* Burst inhibit			*/
-#define OR_SCY_MSK	0x000000f0	/* Cycle Lenght in Clocks		*/
+#define OR_SCY_MSK	0x000000f0	/* Cycle Length in Clocks		*/
 #define OR_SCY_0_CLK	0x00000000	/* 0 clock cycles wait states		*/
 #define OR_SCY_1_CLK	0x00000010	/* 1 clock cycles wait states		*/
 #define OR_SCY_2_CLK	0x00000020	/* 2 clock cycles wait states		*/
diff --git a/include/asm-ppc/commproc.h b/include/asm-ppc/commproc.h
index 3972487..462abb1 100644
--- a/include/asm-ppc/commproc.h
+++ b/include/asm-ppc/commproc.h
@@ -681,7 +681,7 @@ typedef struct risc_timer_pram {
 #define	CICR_SCC_SCC3		((uint)0x00200000)	/* SCC3 @ SCCc */
 #define	CICR_SCB_SCC2		((uint)0x00040000)	/* SCC2 @ SCCb */
 #define	CICR_SCA_SCC1		((uint)0x00000000)	/* SCC1 @ SCCa */
-#define CICR_IRL_MASK		((uint)0x0000e000)	/* Core interrrupt */
+#define CICR_IRL_MASK		((uint)0x0000e000)	/* Core interrupt */
 #define CICR_HP_MASK		((uint)0x00001f00)	/* Hi-pri int. */
 #define CICR_IEN		((uint)0x00000080)	/* Int. enable */
 #define CICR_SPS		((uint)0x00000001)	/* SCC Spread */
diff --git a/include/asm-ppc/reg_booke.h b/include/asm-ppc/reg_booke.h
index 82948ed..4cad45a 100644
--- a/include/asm-ppc/reg_booke.h
+++ b/include/asm-ppc/reg_booke.h
@@ -283,7 +283,7 @@
 #define ESR_IMCB	0x20000000	/* Instr. Machine Check - Bus error */
 #define ESR_IMCT	0x10000000	/* Instr. Machine Check - Timeout */
 #define ESR_PIL		0x08000000	/* Program Exception - Illegal */
-#define ESR_PPR		0x04000000	/* Program Exception - Priveleged */
+#define ESR_PPR		0x04000000	/* Program Exception - Privileged */
 #define ESR_PTR		0x02000000	/* Program Exception - Trap */
 #define ESR_FP		0x01000000	/* Floating Point Operation */
 #define ESR_DST		0x00800000	/* Storage Exception - Data miss */
-- 
1.5.3.7.949.g2221a6

