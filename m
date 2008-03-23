Return-Path: <linux-kernel-owner+w=401wt.eu-S1759808AbYCWIKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759808AbYCWIKt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758278AbYCWIHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:07:46 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1991 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755734AbYCWIHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:07:40 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 022/148] include/asm-x86/desc_defs.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:57 -0700
Message-Id: <1206259443-13210-23-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/desc_defs.h |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/asm-x86/desc_defs.h b/include/asm-x86/desc_defs.h
index e33f078..eccb4ea 100644
--- a/include/asm-x86/desc_defs.h
+++ b/include/asm-x86/desc_defs.h
@@ -18,17 +18,19 @@
  * incrementally. We keep the signature as a struct, rather than an union,
  * so we can get rid of it transparently in the future -- glommer
  */
-// 8 byte segment descriptor
+/* 8 byte segment descriptor */
 struct desc_struct {
 	union {
-		struct { unsigned int a, b; };
+		struct {
+			unsigned int a;
+			unsigned int b;
+		};
 		struct {
 			u16 limit0;
 			u16 base0;
 			unsigned base1: 8, type: 4, s: 1, dpl: 2, p: 1;
 			unsigned limit: 4, avl: 1, l: 1, d: 1, g: 1, base2: 8;
 		};
-
 	};
 } __attribute__((packed));
 
@@ -39,7 +41,7 @@ enum {
 	GATE_TASK = 0x5,
 };
 
-// 16byte gate
+/* 16byte gate */
 struct gate_struct64 {
 	u16 offset_low;
 	u16 segment;
@@ -56,10 +58,10 @@ struct gate_struct64 {
 enum {
 	DESC_TSS = 0x9,
 	DESC_LDT = 0x2,
-	DESCTYPE_S =	0x10,	/* !system */
+	DESCTYPE_S = 0x10,	/* !system */
 };
 
-// LDT or TSS descriptor in the GDT. 16 bytes.
+/* LDT or TSS descriptor in the GDT. 16 bytes. */
 struct ldttss_desc64 {
 	u16 limit0;
 	u16 base0;
@@ -84,7 +86,6 @@ struct desc_ptr {
 	unsigned long address;
 } __attribute__((packed)) ;
 
-
 #endif /* !__ASSEMBLY__ */
 
 #endif
-- 
1.5.4.rc2

