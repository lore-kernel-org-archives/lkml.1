Return-Path: <linux-kernel-owner+w=401wt.eu-S936709AbXLQUCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936709AbXLQUCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934023AbXLQTld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:41:33 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3209 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932382AbXLQTlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:41:21 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH] include/asm-m68knommu/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:23 -0800
Message-Id: <1197920439-5455-17-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918893.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-m68knommu/bitops.h      |    2 +-
 include/asm-m68knommu/commproc.h    |    2 +-
 include/asm-m68knommu/delay.h       |    2 +-
 include/asm-m68knommu/m5249sim.h    |    4 ++--
 include/asm-m68knommu/m5307sim.h    |   12 ++++++------
 include/asm-m68knommu/m5407sim.h    |   12 ++++++------
 include/asm-m68knommu/m68360_regs.h |    2 +-
 include/asm-m68knommu/mcfuart.h     |    2 +-
 8 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/asm-m68knommu/bitops.h b/include/asm-m68knommu/bitops.h
index f8dfb7b..89b928f 100644
--- a/include/asm-m68knommu/bitops.h
+++ b/include/asm-m68knommu/bitops.h
@@ -262,7 +262,7 @@ static __inline__ unsigned long ext2_find_next_zero_bit(void *addr, unsigned lon
 		 * tmp = __swab32(*(p++));
 		 * tmp |= ~0UL >> (32-offset);
 		 *
-		 * but this would decrease preformance, so we change the
+		 * but this would decrease performance, so we change the
 		 * shift:
 		 */
 		tmp = *(p++);
diff --git a/include/asm-m68knommu/commproc.h b/include/asm-m68knommu/commproc.h
index 0161ebb..36e870b 100644
--- a/include/asm-m68knommu/commproc.h
+++ b/include/asm-m68knommu/commproc.h
@@ -715,7 +715,7 @@ extern void cpm_install_handler(int vec, void (*handler)(void *), void *dev_id);
 #define	CICR_SCC_SCC3		((uint)0x00200000)	/* SCC3 @ SCCc */
 #define	CICR_SCB_SCC2		((uint)0x00040000)	/* SCC2 @ SCCb */
 #define	CICR_SCA_SCC1		((uint)0x00000000)	/* SCC1 @ SCCa */
-#define CICR_IRL_MASK		((uint)0x0000e000)	/* Core interrrupt */
+#define CICR_IRL_MASK		((uint)0x0000e000)	/* Core interrupt */
 #define CICR_HP_MASK		((uint)0x00001f00)	/* Hi-pri int. */
 #define CICR_IEN		((uint)0x00000080)	/* Int. enable */
 #define CICR_SPS		((uint)0x00000001)	/* SCC Spread */
diff --git a/include/asm-m68knommu/delay.h b/include/asm-m68knommu/delay.h
index 04a20fd..55cbd62 100644
--- a/include/asm-m68knommu/delay.h
+++ b/include/asm-m68knommu/delay.h
@@ -68,7 +68,7 @@ static inline void _udelay(unsigned long usecs)
 /*
  *	Moved the udelay() function into library code, no longer inlined.
  *	I had to change the algorithm because we are overflowing now on
- *	the faster ColdFire parts. The code is a little biger, so it makes
+ *	the faster ColdFire parts. The code is a little bigger, so it makes
  *	sense to library it.
  */
 extern void udelay(unsigned long usecs);
diff --git a/include/asm-m68knommu/m5249sim.h b/include/asm-m68knommu/m5249sim.h
index 399814f..366eb86 100644
--- a/include/asm-m68knommu/m5249sim.h
+++ b/include/asm-m68knommu/m5249sim.h
@@ -43,10 +43,10 @@
 #define MCFSIM_CSAR1		0x8c		/* CS 1 Address reg (r/w) */
 #define MCFSIM_CSMR1		0x90		/* CS 1 Mask reg (r/w) */
 #define MCFSIM_CSCR1		0x96		/* CS 1 Control reg (r/w) */
-#define MCFSIM_CSAR2		0x98		/* CS 2 Adress reg (r/w) */
+#define MCFSIM_CSAR2		0x98		/* CS 2 Address reg (r/w) */
 #define MCFSIM_CSMR2		0x9c		/* CS 2 Mask reg (r/w) */
 #define MCFSIM_CSCR2		0xa2		/* CS 2 Control reg (r/w) */
-#define MCFSIM_CSAR3		0xa4		/* CS 3 Adress reg (r/w) */
+#define MCFSIM_CSAR3		0xa4		/* CS 3 Address reg (r/w) */
 #define MCFSIM_CSMR3		0xa8		/* CS 3 Mask reg (r/w) */
 #define MCFSIM_CSCR3		0xae		/* CS 3 Control reg (r/w) */
 
diff --git a/include/asm-m68knommu/m5307sim.h b/include/asm-m68knommu/m5307sim.h
index d3ce550..5886728 100644
--- a/include/asm-m68knommu/m5307sim.h
+++ b/include/asm-m68knommu/m5307sim.h
@@ -64,22 +64,22 @@
 #define MCFSIM_CSMR7		0xda		/* CS 7 Mask reg (r/w) */
 #define MCFSIM_CSCR7		0xde		/* CS 7 Control reg (r/w) */
 #else
-#define MCFSIM_CSAR2		0x98		/* CS 2 Adress reg (r/w) */
+#define MCFSIM_CSAR2		0x98		/* CS 2 Address reg (r/w) */
 #define MCFSIM_CSMR2		0x9c		/* CS 2 Mask reg (r/w) */
 #define MCFSIM_CSCR2		0xa2		/* CS 2 Control reg (r/w) */
-#define MCFSIM_CSAR3		0xa4		/* CS 3 Adress reg (r/w) */
+#define MCFSIM_CSAR3		0xa4		/* CS 3 Address reg (r/w) */
 #define MCFSIM_CSMR3		0xa8		/* CS 3 Mask reg (r/w) */
 #define MCFSIM_CSCR3		0xae		/* CS 3 Control reg (r/w) */
-#define MCFSIM_CSAR4		0xb0		/* CS 4 Adress reg (r/w) */
+#define MCFSIM_CSAR4		0xb0		/* CS 4 Address reg (r/w) */
 #define MCFSIM_CSMR4		0xb4		/* CS 4 Mask reg (r/w) */
 #define MCFSIM_CSCR4		0xba		/* CS 4 Control reg (r/w) */
-#define MCFSIM_CSAR5		0xbc		/* CS 5 Adress reg (r/w) */
+#define MCFSIM_CSAR5		0xbc		/* CS 5 Address reg (r/w) */
 #define MCFSIM_CSMR5		0xc0		/* CS 5 Mask reg (r/w) */
 #define MCFSIM_CSCR5		0xc6		/* CS 5 Control reg (r/w) */
-#define MCFSIM_CSAR6		0xc8		/* CS 6 Adress reg (r/w) */
+#define MCFSIM_CSAR6		0xc8		/* CS 6 Address reg (r/w) */
 #define MCFSIM_CSMR6		0xcc		/* CS 6 Mask reg (r/w) */
 #define MCFSIM_CSCR6		0xd2		/* CS 6 Control reg (r/w) */
-#define MCFSIM_CSAR7		0xd4		/* CS 7 Adress reg (r/w) */
+#define MCFSIM_CSAR7		0xd4		/* CS 7 Address reg (r/w) */
 #define MCFSIM_CSMR7		0xd8		/* CS 7 Mask reg (r/w) */
 #define MCFSIM_CSCR7		0xde		/* CS 7 Control reg (r/w) */
 #endif /* CONFIG_OLDMASK */
diff --git a/include/asm-m68knommu/m5407sim.h b/include/asm-m68knommu/m5407sim.h
index 75dcdac..cc22c4a 100644
--- a/include/asm-m68knommu/m5407sim.h
+++ b/include/asm-m68knommu/m5407sim.h
@@ -48,22 +48,22 @@
 #define MCFSIM_CSMR1		0x90		/* CS 1 Mask reg (r/w) */
 #define MCFSIM_CSCR1		0x96		/* CS 1 Control reg (r/w) */
 
-#define MCFSIM_CSAR2		0x98		/* CS 2 Adress reg (r/w) */
+#define MCFSIM_CSAR2		0x98		/* CS 2 Address reg (r/w) */
 #define MCFSIM_CSMR2		0x9c		/* CS 2 Mask reg (r/w) */
 #define MCFSIM_CSCR2		0xa2		/* CS 2 Control reg (r/w) */
-#define MCFSIM_CSAR3		0xa4		/* CS 3 Adress reg (r/w) */
+#define MCFSIM_CSAR3		0xa4		/* CS 3 Address reg (r/w) */
 #define MCFSIM_CSMR3		0xa8		/* CS 3 Mask reg (r/w) */
 #define MCFSIM_CSCR3		0xae		/* CS 3 Control reg (r/w) */
-#define MCFSIM_CSAR4		0xb0		/* CS 4 Adress reg (r/w) */
+#define MCFSIM_CSAR4		0xb0		/* CS 4 Address reg (r/w) */
 #define MCFSIM_CSMR4		0xb4		/* CS 4 Mask reg (r/w) */
 #define MCFSIM_CSCR4		0xba		/* CS 4 Control reg (r/w) */
-#define MCFSIM_CSAR5		0xbc		/* CS 5 Adress reg (r/w) */
+#define MCFSIM_CSAR5		0xbc		/* CS 5 Address reg (r/w) */
 #define MCFSIM_CSMR5		0xc0		/* CS 5 Mask reg (r/w) */
 #define MCFSIM_CSCR5		0xc6		/* CS 5 Control reg (r/w) */
-#define MCFSIM_CSAR6		0xc8		/* CS 6 Adress reg (r/w) */
+#define MCFSIM_CSAR6		0xc8		/* CS 6 Address reg (r/w) */
 #define MCFSIM_CSMR6		0xcc		/* CS 6 Mask reg (r/w) */
 #define MCFSIM_CSCR6		0xd2		/* CS 6 Control reg (r/w) */
-#define MCFSIM_CSAR7		0xd4		/* CS 7 Adress reg (r/w) */
+#define MCFSIM_CSAR7		0xd4		/* CS 7 Address reg (r/w) */
 #define MCFSIM_CSMR7		0xd8		/* CS 7 Mask reg (r/w) */
 #define MCFSIM_CSCR7		0xde		/* CS 7 Control reg (r/w) */
 
diff --git a/include/asm-m68knommu/m68360_regs.h b/include/asm-m68knommu/m68360_regs.h
index a3f8cc8..d57217c 100644
--- a/include/asm-m68knommu/m68360_regs.h
+++ b/include/asm-m68knommu/m68360_regs.h
@@ -138,7 +138,7 @@
 #define CICR_SCC_SCC3           ((uint)0x00200000)      /* SCC3 @ SCCc */
 #define CICR_SCD_SCC4           ((uint)0x00c00000)      /* SCC4 @ SCCd */
 
-#define CICR_IRL_MASK           ((uint)0x0000e000)      /* Core interrrupt */
+#define CICR_IRL_MASK           ((uint)0x0000e000)      /* Core interrupt */
 #define CICR_HP_MASK            ((uint)0x00001f00)      /* Hi-pri int. */
 #define CICR_VBA_MASK           ((uint)0x000000e0)      /* Vector Base Address */
 #define CICR_SPS                ((uint)0x00000001)      /* SCC Spread */
diff --git a/include/asm-m68knommu/mcfuart.h b/include/asm-m68knommu/mcfuart.h
index 873d080..873876d 100644
--- a/include/asm-m68knommu/mcfuart.h
+++ b/include/asm-m68knommu/mcfuart.h
@@ -72,7 +72,7 @@ struct mcf_platform_uart {
 #define	MCFUART_UTB		0x0c		/* Transmit Buffer (w) */
 #define	MCFUART_UIPCR		0x10		/* Input Port Change (r) */
 #define	MCFUART_UACR		0x10		/* Auxiliary Control (w) */
-#define	MCFUART_UISR		0x14		/* Interrup Status (r) */
+#define	MCFUART_UISR		0x14		/* Interrupt Status (r) */
 #define	MCFUART_UIMR		0x14		/* Interrupt Mask (w) */
 #define	MCFUART_UBG1		0x18		/* Baud Rate MSB (r/w) */
 #define	MCFUART_UBG2		0x1c		/* Baud Rate LSB (r/w) */
-- 
1.5.3.7.949.g2221a6

