Return-Path: <linux-kernel-owner+w=401wt.eu-S1765561AbYCWIny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765561AbYCWIny (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757929AbYCWIK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:56 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2314 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759380AbYCWIKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:49 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 073/148] include/asm-x86/mpspec_def.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:48 -0700
Message-Id: <1206259443-13210-74-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/mpspec_def.h |   35 +++++++++++++----------------------
 1 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/include/asm-x86/mpspec_def.h b/include/asm-x86/mpspec_def.h
index 1f35691..dc6ef85 100644
--- a/include/asm-x86/mpspec_def.h
+++ b/include/asm-x86/mpspec_def.h
@@ -11,7 +11,7 @@
  * information is.
  */
 
-#define SMP_MAGIC_IDENT	(('_'<<24)|('P'<<16)|('M'<<8)|'_')
+#define SMP_MAGIC_IDENT	(('_'<<24) | ('P'<<16) | ('M'<<8) | '_')
 
 #ifdef CONFIG_X86_32
 # define MAX_MPC_ENTRY 1024
@@ -23,8 +23,7 @@
 # define MAX_APICS 255
 #endif
 
-struct intel_mp_floating
-{
+struct intel_mp_floating {
 	char mpf_signature[4];		/* "_MP_"			*/
 	unsigned int mpf_physptr;	/* Configuration table address	*/
 	unsigned char mpf_length;	/* Our length (paragraphs)	*/
@@ -39,14 +38,13 @@ struct intel_mp_floating
 
 #define MPC_SIGNATURE "PCMP"
 
-struct mp_config_table
-{
+struct mp_config_table {
 	char mpc_signature[4];
 	unsigned short mpc_length;	/* Size of table */
-	char  mpc_spec;			/* 0x01 */
-	char  mpc_checksum;
-	char  mpc_oem[8];
-	char  mpc_productid[12];
+	char mpc_spec;			/* 0x01 */
+	char mpc_checksum;
+	char mpc_oem[8];
+	char mpc_productid[12];
 	unsigned int mpc_oemptr;	/* 0 if not present */
 	unsigned short mpc_oemsize;	/* 0 if not present */
 	unsigned short mpc_oemcount;
@@ -71,8 +69,7 @@ struct mp_config_table
 #define CPU_MODEL_MASK		0x00F0
 #define CPU_FAMILY_MASK		0x0F00
 
-struct mpc_config_processor
-{
+struct mpc_config_processor {
 	unsigned char mpc_type;
 	unsigned char mpc_apicid;	/* Local APIC number */
 	unsigned char mpc_apicver;	/* Its versions */
@@ -82,8 +79,7 @@ struct mpc_config_processor
 	unsigned int mpc_reserved[2];
 };
 
-struct mpc_config_bus
-{
+struct mpc_config_bus {
 	unsigned char mpc_type;
 	unsigned char mpc_busid;
 	unsigned char mpc_bustype[6];
@@ -111,8 +107,7 @@ struct mpc_config_bus
 
 #define MPC_APIC_USABLE		0x01
 
-struct mpc_config_ioapic
-{
+struct mpc_config_ioapic {
 	unsigned char mpc_type;
 	unsigned char mpc_apicid;
 	unsigned char mpc_apicver;
@@ -120,8 +115,7 @@ struct mpc_config_ioapic
 	unsigned int mpc_apicaddr;
 };
 
-struct mpc_config_intsrc
-{
+struct mpc_config_intsrc {
 	unsigned char mpc_type;
 	unsigned char mpc_irqtype;
 	unsigned short mpc_irqflag;
@@ -144,8 +138,7 @@ enum mp_irq_source_types {
 
 #define MP_APIC_ALL	0xFF
 
-struct mpc_config_lintsrc
-{
+struct mpc_config_lintsrc {
 	unsigned char mpc_type;
 	unsigned char mpc_irqtype;
 	unsigned short mpc_irqflag;
@@ -157,8 +150,7 @@ struct mpc_config_lintsrc
 
 #define MPC_OEM_SIGNATURE "_OEM"
 
-struct mp_config_oemtable
-{
+struct mp_config_oemtable {
 	char oem_signature[4];
 	unsigned short oem_length;	/* Size of table */
 	char  oem_rev;			/* 0x01 */
@@ -185,4 +177,3 @@ enum mp_bustype {
 	MP_BUS_MCA,
 };
 #endif
-
-- 
1.5.4.rc2

