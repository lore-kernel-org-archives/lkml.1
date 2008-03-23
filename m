Return-Path: <linux-kernel-owner+w=401wt.eu-S933401AbYCWI4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401AbYCWI4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760198AbYCWILv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:51 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2345 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760140AbYCWILo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:44 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 145/148] include/asm-x86/voyager.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:04:00 -0700
Message-Id: <1206259443-13210-146-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/voyager.h |   51 +++++++++++++++++++++++++++-----------------
 1 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/include/asm-x86/voyager.h b/include/asm-x86/voyager.h
index 91a9932..9c811d2 100644
--- a/include/asm-x86/voyager.h
+++ b/include/asm-x86/voyager.h
@@ -91,8 +91,7 @@
 #define VOYAGER_WRITE_CONFIG			0x2
 #define VOYAGER_BYPASS				0xff
 
-typedef struct voyager_asic 
-{
+typedef struct voyager_asic {
 	__u8	asic_addr;	/* ASIC address; Level 4 */
 	__u8	asic_type;      /* ASIC type */
 	__u8	asic_id;	/* ASIC id */
@@ -113,7 +112,7 @@ typedef struct voyager_module {
 	__u16   largest_reg;		/* Largest register in the scan path */
 	__u16   smallest_reg;		/* Smallest register in the scan path */
 	voyager_asic_t   *asic;		/* First ASIC in scan path (CAT_I) */
-	struct   voyager_module *submodule;	/* Submodule pointer */ 
+	struct   voyager_module *submodule;	/* Submodule pointer */
 	struct   voyager_module *next;		/* Next module in linked list */
 } voyager_module_t;
 
@@ -135,7 +134,7 @@ typedef struct voyager_eeprom_hdr {
 	 __u16 cct_offset;
 	 __u16 log_length;	/* length of err log */
 	 __u16 xsum_end;	/* offset to end of
-							   checksum */
+				   checksum */
 	 __u8  reserved[4];
 	 __u8  sflag;		/* starting sentinal */
 	 __u8  part_number[13];	/* prom part number */
@@ -148,7 +147,8 @@ typedef struct voyager_eeprom_hdr {
 
 
 
-#define VOYAGER_EPROM_SIZE_OFFSET   ((__u16)(&(((voyager_eprom_hdr_t *)0)->ee_size)))
+#define VOYAGER_EPROM_SIZE_OFFSET				\
+	((__u16)(&(((voyager_eprom_hdr_t *)0)->ee_size)))
 #define VOYAGER_XSUM_END_OFFSET		0x2a
 
 /* the following three definitions are for internal table layouts
@@ -199,7 +199,7 @@ typedef struct voyager_asic_data_table {
 #define VOYAGER_WCBIC_TOM_L	0x4
 #define VOYAGER_WCBIC_TOM_H	0x5
 
-/* register defines for Voyager Memory Contol (VMC) 
+/* register defines for Voyager Memory Contol (VMC)
  * these are present on L4 machines only */
 #define	VOYAGER_VMC1		0x81
 #define VOYAGER_VMC2		0x91
@@ -334,7 +334,7 @@ typedef struct {
 
 struct QuadDescription {
 	__u8  Type;	/* for type 0 (DYADIC or MONADIC) all fields
-                         * will be zero except for slot */
+			 * will be zero except for slot */
 	__u8 StructureVersion;
 	__u32 CPI_BaseAddress;
 	__u32  LARC_BankSize;
@@ -342,7 +342,7 @@ struct QuadDescription {
 	__u8  Slot; /* Processor slots 1 - 4 */
 } __attribute__((packed));
 
-struct ProcBoardInfo { 
+struct ProcBoardInfo {
 	__u8 Type;
 	__u8 StructureVersion;
 	__u8 NumberOfBoards;
@@ -382,19 +382,30 @@ struct CPU_Info {
  * packed in it by our friend the compiler.
  */
 typedef struct {
-	__u8	Mailbox_SUS;		/* Written to by SUS to give commands/response to the OS */
-	__u8	Mailbox_OS;		/* Written to by the OS to give commands/response to SUS */
-	__u8	SUS_MailboxVersion;	/* Tells the OS which iteration of the interface SUS supports */
-	__u8	OS_MailboxVersion;	/* Tells SUS which iteration of the interface the OS supports */
-	__u32	OS_Flags;		/* Flags set by the OS as info for SUS */
-	__u32	SUS_Flags;		/* Flags set by SUS as info for the OS */
-	__u32	WatchDogPeriod;		/* Watchdog period (in seconds) which the DP uses to see if the OS is dead */
+	__u8	Mailbox_SUS;		/* Written to by SUS to give
+					   commands/response to the OS */
+	__u8	Mailbox_OS;		/* Written to by the OS to give
+					   commands/response to SUS */
+	__u8	SUS_MailboxVersion;	/* Tells the OS which iteration of the
+					   interface SUS supports */
+	__u8	OS_MailboxVersion;	/* Tells SUS which iteration of the
+					   interface the OS supports */
+	__u32	OS_Flags;		/* Flags set by the OS as info for
+					   SUS */
+	__u32	SUS_Flags;		/* Flags set by SUS as info
+					   for the OS */
+	__u32	WatchDogPeriod;		/* Watchdog period (in seconds) which
+					   the DP uses to see if the OS
+					   is dead */
 	__u32	WatchDogCount;		/* Updated by the OS on every tic. */
-	__u32	MemoryFor_SUS_ErrorLog;	/* Flat 32 bit address which tells SUS where to stuff the SUS error log on a dump */
-	MC_SlotInformation_t  MC_SlotInfo[NUMBER_OF_MC_BUSSES*SLOTS_PER_MC_BUS];	/* Storage for MCA POS data */
+	__u32	MemoryFor_SUS_ErrorLog;	/* Flat 32 bit address which tells SUS
+					   where to stuff the SUS error log
+					   on a dump */
+	MC_SlotInformation_t MC_SlotInfo[NUMBER_OF_MC_BUSSES*SLOTS_PER_MC_BUS];
+					/* Storage for MCA POS data */
 	/* All new SECOND_PASS_INTERFACE fields added from this point */
-        struct ProcBoardInfo    *BoardData;
-        struct CPU_Info         *CPU_Data;
+	struct ProcBoardInfo    *BoardData;
+	struct CPU_Info         *CPU_Data;
 	/* All new fields must be added from this point */
 } Voyager_KernelSUS_Mbox_t;
 
@@ -478,7 +489,7 @@ struct voyager_SUS {
 	__u32	SUS_errorlog;
 	/* lots of system configuration stuff under here */
 };
-	
+
 /* Variables exported by voyager_smp */
 extern __u32 voyager_extended_vic_processors;
 extern __u32 voyager_allowed_boot_processors;
-- 
1.5.4.rc2

