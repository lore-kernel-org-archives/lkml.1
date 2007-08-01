Return-Path: <linux-kernel-owner+w=401wt.eu-S1757632AbXHADQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632AbXHADQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 23:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbXHADQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 23:16:46 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:60316 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbXHADQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 23:16:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=YHfyw6JnIOfHy+uVt6Hl6RL4mWWr+HATLJWkcrByGlFLPfLrTPf6mPlK/N9k2REAuIprfwWbF7etP57UQCWyFm57dhVdKlRBtFOhZAA8qUVKnuBKC0TZ21XBbYKoQi4bB1UWpEHtV2sPU6+72lKVDxNjoEdJFTAZhBcfWkWkxrU=
Message-ID: <46AFFB0B.102@googlemail.com>
Date: Wed, 01 Aug 2007 05:16:27 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: linuxppc-dev@ozlabs.org, linuxppc-embedded@ozlabs.org
Subject: [PATCH] [POWERPC] Typo fixes interrrupt -> interrupt
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch fixes some interrrupt -> interrupt typos and the comments in it_lp_naca.h

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

 arch/powerpc/platforms/embedded6xx/holly.c        |    2 +-
 arch/powerpc/platforms/embedded6xx/linkstation.c  |    2 +-
 arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c |    2 +-
 arch/powerpc/platforms/iseries/it_lp_naca.h       |   87 +++++++++++----------
 include/asm-ppc/commproc.h                        |    2 +-
 5 files changed, 49 insertions(+), 46 deletions(-)

diff --git a/arch/powerpc/platforms/embedded6xx/holly.c b/arch/powerpc/platforms/embedded6xx/holly.c
index 6292e36..fda16e8 100644
--- a/arch/powerpc/platforms/embedded6xx/holly.c
+++ b/arch/powerpc/platforms/embedded6xx/holly.c
@@ -147,7 +147,7 @@ static void __init holly_setup_arch(void)
 }
 
 /*
- * Interrupt setup and service.  Interrrupts on the holly come
+ * Interrupt setup and service.  Interrupts on the holly come
  * from the four external INT pins, PCI interrupts are routed via
  * PCI interrupt control registers, it generates internal IRQ23
  *
diff --git a/arch/powerpc/platforms/embedded6xx/linkstation.c b/arch/powerpc/platforms/embedded6xx/linkstation.c
index bd5ca58..8c60e02 100644
--- a/arch/powerpc/platforms/embedded6xx/linkstation.c
+++ b/arch/powerpc/platforms/embedded6xx/linkstation.c
@@ -99,7 +99,7 @@ static void __init linkstation_setup_arch(void)
 }
 
 /*
- * Interrupt setup and service.  Interrrupts on the linkstation come
+ * Interrupt setup and service.  Interrupts on the linkstation come
  * from the four PCI slots plus onboard 8241 devices: I2C, DUART.
  */
 static void __init linkstation_init_IRQ(void)
diff --git a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c b/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
index 1e3cc69..25c29bc 100644
--- a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
+++ b/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
@@ -91,7 +91,7 @@ static void __init mpc7448_hpc2_setup_arch(void)
 }
 
 /*
- * Interrupt setup and service.  Interrrupts on the mpc7448_hpc2 come
+ * Interrupt setup and service.  Interrupts on the mpc7448_hpc2 come
  * from the four external INT pins, PCI interrupts are routed via
  * PCI interrupt control registers, it generates internal IRQ23
  *
diff --git a/arch/powerpc/platforms/iseries/it_lp_naca.h b/arch/powerpc/platforms/iseries/it_lp_naca.h
index 9bbf589..46060bb 100644
--- a/arch/powerpc/platforms/iseries/it_lp_naca.h
+++ b/arch/powerpc/platforms/iseries/it_lp_naca.h
@@ -21,53 +21,56 @@
 #include <linux/types.h>
 
 /*
- *	This control block contains the data that is shared between the
- *	hypervisor (PLIC) and the OS.
+ * This control block contains the data that is shared between the
+ * hypervisor (PLIC) and the OS.
  */
-
 struct ItLpNaca {
-// CACHE_LINE_1 0x0000 - 0x007F Contains read-only data
-	u32	xDesc;			// Eye catcher			x00-x03
-	u16	xSize;			// Size of this class		x04-x05
-	u16	xIntHdlrOffset;		// Offset to IntHdlr array	x06-x07
-	u8	xMaxIntHdlrEntries;	// Number of entries in array	x08-x08
-	u8	xPrimaryLpIndex;	// LP Index of Primary		x09-x09
-	u8	xServiceLpIndex;	// LP Ind of Service Focal Pointx0A-x0A
-	u8	xLpIndex;		// LP Index			x0B-x0B
-	u16	xMaxLpQueues;		// Number of allocated queues	x0C-x0D
-	u16	xLpQueueOffset;		// Offset to start of LP queues	x0E-x0F
-	u8	xPirEnvironMode;	// Piranha or hardware		x10-x10
-	u8	xPirConsoleMode;	// Piranha console indicator	x11-x11
-	u8	xPirDasdMode;		// Piranha dasd indicator	x12-x12
-	u8	xRsvd1_0[5];		// Reserved for Piranha related	x13-x17
-	u8	flags;			// flags, see below		x18-x1F
-	u8	xSpVpdFormat;		// VPD areas are in CSP format	...
-	u8	xIntProcRatio;		// Ratio of int procs to procs	...
-	u8	xRsvd1_2[5];		// Reserved			...
-	u16	xRsvd1_3;		// Reserved			x20-x21
-	u16	xPlicVrmIndex;		// VRM index of PLIC		x22-x23
-	u16	xMinSupportedSlicVrmInd;// Min supported OS VRM index	x24-x25
-	u16	xMinCompatableSlicVrmInd;// Min compatible OS VRM index x26-x27
-	u64	xLoadAreaAddr;		// ER address of load area	x28-x2F
-	u32	xLoadAreaChunks;	// Chunks for the load area	x30-x33
-	u32	xPaseSysCallCRMask;	// Mask used to test CR before  x34-x37
-					// doing an ASR switch on PASE
-					// system call.
-	u64	xSlicSegmentTablePtr;	// Pointer to Slic seg table.   x38-x3f
-	u8	xRsvd1_4[64];		//				x40-x7F
+/* CACHE_LINE_1 0x0000 - 0x007F Contains read-only data */
+	u32	xDesc;				/* Eye catcher			x00-x03 */
+	u16	xSize;				/* Size of this class		x04-x05 */
+	u16	xIntHdlrOffset;			/* Offset to IntHdlr array	x06-x07 */
+	u8	xMaxIntHdlrEntries;		/* Number of entries in array	x08-x08 */
+	u8	xPrimaryLpIndex;		/* LP Index of Primary		x09-x09 */
+	u8	xServiceLpIndex;		/* LP Ind of Service Focal Pointx0A-x0A */
+	u8	xLpIndex;			/* LP Index			x0B-x0B */
+	u16	xMaxLpQueues;			/* Number of allocated queues	x0C-x0D */
+	u16	xLpQueueOffset;			/* Offset to start of LP queues	x0E-x0F */
+	u8	xPirEnvironMode;		/* Piranha or hardware		x10-x10 */
+	u8	xPirConsoleMode;		/* Piranha console indicator	x11-x11 */
+	u8	xPirDasdMode;			/* Piranha dasd indicator	x12-x12 */
+	u8	xRsvd1_0[5];			/* Reserved for Piranha related	x13-x17 */
+	u8	flags;				/* flags, see below		x18-x1F */
+	u8	xSpVpdFormat;			/* VPD areas are in CSP format	... */
+	u8	xIntProcRatio;			/* Ratio of int procs to procs	... */
+	u8	xRsvd1_2[5];			/* Reserved			... */
+	u16	xRsvd1_3;			/* Reserved			x20-x21 */
+	u16	xPlicVrmIndex;			/* VRM index of PLIC		x22-x23 */
+	u16	xMinSupportedSlicVrmInd;	/* Min supported OS VRM index	x24-x25 */
+	u16	xMinCompatableSlicVrmInd;	/* Min compatible OS VRM index x26-x27 */
+	u64	xLoadAreaAddr;			/* ER address of load area	x28-x2F */
+	u32	xLoadAreaChunks;		/* Chunks for the load area	x30-x33 */
+	u32	xPaseSysCallCRMask;		/* Mask used to test CR before  x34-x37 */
+						/* doing an ASR switch on PASE */
+						/* system call. */
+	u64	xSlicSegmentTablePtr;		/* Pointer to Slic seg table.   x38-x3f */
+	u8	xRsvd1_4[64];			/*				x40-x7F */
 
-// CACHE_LINE_2 0x0080 - 0x00FF Contains local read-write data
-	u8	xRsvd2_0[128];		// Reserved			x00-x7F
+/* CACHE_LINE_2 0x0080 - 0x00FF Contains local read-write data */
+	u8	xRsvd2_0[128];		/* Reserved			x00-x7F */
 
-// CACHE_LINE_3-6 0x0100 - 0x02FF Contains LP Queue indicators
-// NB: Padding required to keep xInterrruptHdlr at x300 which is required
-// for v4r4 PLIC.
-	u8	xOldLpQueue[128];	// LP Queue needed for v4r4	100-17F
-	u8	xRsvd3_0[384];		// Reserved			180-2FF
+/*
+ * CACHE_LINE_3-6 0x0100 - 0x02FF Contains LP Queue indicators
+ * NB: Padding required to keep xInterruptHdlr at x300 which is required
+ * for v4r4 PLIC.
+ */
+	u8	xOldLpQueue[128];	/* LP Queue needed for v4r4	100-17F */
+	u8	xRsvd3_0[384];		/* Reserved			180-2FF */
 
-// CACHE_LINE_7-8 0x0300 - 0x03FF Contains the address of the OS interrupt
-//  handlers
-	u64	xInterruptHdlr[32];	// Interrupt handlers		300-x3FF
+/*
+ * CACHE_LINE_7-8 0x0300 - 0x03FF Contains the address of the OS interrupt
+ * handlers
+ */
+	u64	xInterruptHdlr[32];	/* Interrupt handlers		300-x3FF */
 };
 
 extern struct ItLpNaca		itLpNaca;
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
