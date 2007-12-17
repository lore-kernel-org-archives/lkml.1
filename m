Return-Path: <linux-kernel-owner+w=401wt.eu-S1762854AbXLQTgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762854AbXLQTgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760820AbXLQTbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:36 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2955 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760437AbXLQTbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:32 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
       anton@au.ibm.com, linuxppc-dev@ozlabs.org, paulus@au.ibm.com
Subject: [PATCH] include/asm-powerpc/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:13 -0800
Message-Id: <1197919875-5288-14-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-powerpc/8xx_immap.h           |    2 +-
 include/asm-powerpc/commproc.h            |    2 +-
 include/asm-powerpc/iseries/hv_lp_event.h |    2 +-
 include/asm-powerpc/reg_booke.h           |    2 +-
 include/asm-powerpc/smu.h                 |   12 ++++++------
 include/asm-powerpc/spu.h                 |    2 +-
 include/asm-powerpc/spu_csa.h             |    2 +-
 7 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/asm-powerpc/8xx_immap.h b/include/asm-powerpc/8xx_immap.h
index 1311cef..4b0e152 100644
--- a/include/asm-powerpc/8xx_immap.h
+++ b/include/asm-powerpc/8xx_immap.h
@@ -123,7 +123,7 @@ typedef struct	mem_ctlr {
 #define OR_G5LA		0x00000400	/* Output #GPL5 on #GPL_A5		*/
 #define OR_G5LS		0x00000200	/* Drive #GPL high on falling edge of...*/
 #define OR_BI		0x00000100	/* Burst inhibit			*/
-#define OR_SCY_MSK	0x000000f0	/* Cycle Lenght in Clocks		*/
+#define OR_SCY_MSK	0x000000f0	/* Cycle Length in Clocks		*/
 #define OR_SCY_0_CLK	0x00000000	/* 0 clock cycles wait states		*/
 #define OR_SCY_1_CLK	0x00000010	/* 1 clock cycles wait states		*/
 #define OR_SCY_2_CLK	0x00000020	/* 2 clock cycles wait states		*/
diff --git a/include/asm-powerpc/commproc.h b/include/asm-powerpc/commproc.h
index a2328b8..0e192cc 100644
--- a/include/asm-powerpc/commproc.h
+++ b/include/asm-powerpc/commproc.h
@@ -693,7 +693,7 @@ typedef struct risc_timer_pram {
 #define	CICR_SCC_SCC3		((uint)0x00200000)	/* SCC3 @ SCCc */
 #define	CICR_SCB_SCC2		((uint)0x00040000)	/* SCC2 @ SCCb */
 #define	CICR_SCA_SCC1		((uint)0x00000000)	/* SCC1 @ SCCa */
-#define CICR_IRL_MASK		((uint)0x0000e000)	/* Core interrrupt */
+#define CICR_IRL_MASK		((uint)0x0000e000)	/* Core interrupt */
 #define CICR_HP_MASK		((uint)0x00001f00)	/* Hi-pri int. */
 #define CICR_IEN		((uint)0x00000080)	/* Int. enable */
 #define CICR_SPS		((uint)0x00000001)	/* SCC Spread */
diff --git a/include/asm-powerpc/iseries/hv_lp_event.h b/include/asm-powerpc/iseries/hv_lp_event.h
index 6ce2ce1..8f5da7d 100644
--- a/include/asm-powerpc/iseries/hv_lp_event.h
+++ b/include/asm-powerpc/iseries/hv_lp_event.h
@@ -78,7 +78,7 @@ extern int HvLpEvent_openPath(HvLpEvent_Type eventType, HvLpIndex lpIndex);
 
 /*
  * Close an Lp Event Path for a type and partition
- * returns 0 on sucess
+ * returns 0 on success
  */
 extern int HvLpEvent_closePath(HvLpEvent_Type eventType, HvLpIndex lpIndex);
 
diff --git a/include/asm-powerpc/reg_booke.h b/include/asm-powerpc/reg_booke.h
index 8fdc2b4..5e551f4 100644
--- a/include/asm-powerpc/reg_booke.h
+++ b/include/asm-powerpc/reg_booke.h
@@ -293,7 +293,7 @@
 #define ESR_IMCB	0x20000000	/* Instr. Machine Check - Bus error */
 #define ESR_IMCT	0x10000000	/* Instr. Machine Check - Timeout */
 #define ESR_PIL		0x08000000	/* Program Exception - Illegal */
-#define ESR_PPR		0x04000000	/* Program Exception - Priveleged */
+#define ESR_PPR		0x04000000	/* Program Exception - Privileged */
 #define ESR_PTR		0x02000000	/* Program Exception - Trap */
 #define ESR_FP		0x01000000	/* Floating Point Operation */
 #define ESR_DST		0x00800000	/* Storage Exception - Data miss */
diff --git a/include/asm-powerpc/smu.h b/include/asm-powerpc/smu.h
index e49f644..bcdd311 100644
--- a/include/asm-powerpc/smu.h
+++ b/include/asm-powerpc/smu.h
@@ -22,7 +22,7 @@
  * Partition info commands
  *
  * These commands are used to retrieve the sdb-partition-XX datas from
- * the SMU. The lenght is always 2. First byte is the subcommand code
+ * the SMU. The length is always 2. First byte is the subcommand code
  * and second byte is the partition ID.
  *
  * The reply is 6 bytes:
@@ -173,12 +173,12 @@
  * Power supply control
  *
  * The "sub" command is an ASCII string in the data, the
- * data lenght is that of the string.
+ * data length is that of the string.
  *
  * The VSLEW command can be used to get or set the voltage slewing.
- *  - lenght 5 (only "VSLEW") : it returns "DONE" and 3 bytes of
+ *  - length 5 (only "VSLEW") : it returns "DONE" and 3 bytes of
  *    reply at data offset 6, 7 and 8.
- *  - lenght 8 ("VSLEWxyz") has 3 additional bytes appended, and is
+ *  - length 8 ("VSLEWxyz") has 3 additional bytes appended, and is
  *    used to set the voltage slewing point. The SMU replies with "DONE"
  * I yet have to figure out their exact meaning of those 3 bytes in
  * both cases. They seem to be:
@@ -564,13 +564,13 @@ struct smu_user_cmd_hdr
 
 	__u8		cmd;			/* SMU command byte */
 	__u8		pad[3];			/* padding */
-	__u32		data_len;		/* Lenght of data following */
+	__u32		data_len;		/* Length of data following */
 };
 
 struct smu_user_reply_hdr
 {
 	__u32		status;			/* Command status */
-	__u32		reply_len;		/* Lenght of data follwing */
+	__u32		reply_len;		/* Length of data follwing */
 };
 
 #endif /*  _SMU_H */
diff --git a/include/asm-powerpc/spu.h b/include/asm-powerpc/spu.h
index b1accce..85ee4ca 100644
--- a/include/asm-powerpc/spu.h
+++ b/include/asm-powerpc/spu.h
@@ -299,7 +299,7 @@ int spu_switch_event_register(struct notifier_block * n);
 int spu_switch_event_unregister(struct notifier_block * n);
 
 /*
- * This defines the Local Store, Problem Area and Privlege Area of an SPU.
+ * This defines the Local Store, Problem Area and Privilege Area of an SPU.
  */
 
 union mfc_tag_size_class_cmd {
diff --git a/include/asm-powerpc/spu_csa.h b/include/asm-powerpc/spu_csa.h
index e87794d..867bc26 100644
--- a/include/asm-powerpc/spu_csa.h
+++ b/include/asm-powerpc/spu_csa.h
@@ -194,7 +194,7 @@ struct spu_priv1_collapsed {
 };
 
 /*
- * struct spu_priv2_collapsed - condensed priviliged 2 area, w/o pads.
+ * struct spu_priv2_collapsed - condensed privileged 2 area, w/o pads.
  */
 struct spu_priv2_collapsed {
 	u64 slb_index_W;
-- 
1.5.3.7.949.g2221a6

