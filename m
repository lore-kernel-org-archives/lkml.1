Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbZJaJ33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbZJaJ33 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 05:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756893AbZJaJ33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 05:29:29 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:33582 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290AbZJaJ32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 05:29:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=CVBuF51EzrVHLYeg0OtzQYrFUMXJZ9xoKx5IQ9Pbrbk7uTWyfR5lWaplY9F1mq9wTU
         cybcSFhLiREfW+tT3cA2aXySpT8+w/LpZ6uqbu39xIcLz/04Ey+eyeyA+IGxQr0ieHOC
         HBAZ4qnSMpPzoJ5ZaRdCCg3HOtWRETCQy1PRk=
MIME-Version: 1.0
Date: Sat, 31 Oct 2009 15:29:32 +0600
Message-ID: <b9df5fa10910310229s2d9f85c1y31403ecbf8c31567@mail.gmail.com>
Subject: [PATCH] x86, apicdef: Fix checkpatch issues in apicdef.h
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 In apicdef.h - we have a checkpatch issue - needs to be fixed.
We were warned by the following checkpatch warning:

ERROR: space prohibited before that ':' (ctx:WxW)
#276: FILE: arch/x86/include/asm/apicdef.h:376:
+                       hi      : 1;
                                ^
---
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/arch/x86/include/asm/apicdef.h	2009-10-17 13:12:59.000000000 +0600
+++ rakib/arch/x86/include/asm/apicdef.h	2009-10-31 16:27:49.000000000 +0600
@@ -170,18 +170,18 @@ struct local_apic {
 /*010*/	struct { u32 __reserved[4]; } __reserved_02;

 /*020*/	struct { /* APIC ID Register */
-		u32   __reserved_1	: 24,
-			phys_apic_id	:  4,
-			__reserved_2	:  4;
+		u32   __reserved_1:24,
+			phys_apic_id:4,
+			__reserved_2:4;
 		u32 __reserved[3];
 	} id;

 /*030*/	const
 	struct { /* APIC Version Register */
-		u32   version		:  8,
-			__reserved_1	:  8,
-			max_lvt		:  8,
-			__reserved_2	:  8;
+		u32   version:8,
+			__reserved_1:8,
+			max_lvt:8,
+			__reserved_2:8;
 		u32 __reserved[3];
 	} version;

@@ -194,22 +194,22 @@ struct local_apic {
 /*070*/	struct { u32 __reserved[4]; } __reserved_06;

 /*080*/	struct { /* Task Priority Register */
-		u32   priority	:  8,
-			__reserved_1	: 24;
+		u32   priority:8,
+			__reserved_1:24;
 		u32 __reserved_2[3];
 	} tpr;

 /*090*/	const
 	struct { /* Arbitration Priority Register */
-		u32   priority	:  8,
-			__reserved_1	: 24;
+		u32   priority:8,
+			__reserved_1:24;
 		u32 __reserved_2[3];
 	} apr;

 /*0A0*/	const
 	struct { /* Processor Priority Register */
-		u32   priority	:  8,
-			__reserved_1	: 24;
+		u32   priority:8,
+			__reserved_1:24;
 		u32 __reserved_2[3];
 	} ppr;

@@ -221,51 +221,55 @@ struct local_apic {
 /*0C0*/	struct { u32 __reserved[4]; } __reserved_07;

 /*0D0*/	struct { /* Logical Destination Register */
-		u32   __reserved_1	: 24,
-			logical_dest	:  8;
+		u32   __reserved_1:24,
+			logical_dest:8;
 		u32 __reserved_2[3];
 	} ldr;

 /*0E0*/	struct { /* Destination Format Register */
-		u32   __reserved_1	: 28,
-			model		:  4;
+		const u32   __reserved_1:28;
+		u32		model:4;
 		u32 __reserved_2[3];
 	} dfr;

 /*0F0*/	struct { /* Spurious Interrupt Vector Register */
-		u32	spurious_vector	:  8,
-			apic_enabled	:  1,
-			focus_cpu	:  1,
-			__reserved_2	: 22;
+		u32 		spurious_vector:8;
+		const u32	apic_enabled:1,
+				focus_cpu:1,
+				__reserved_2:22;
 		u32 __reserved_3[3];
 	} svr;

-/*100*/	struct { /* In Service Register */
-/*170*/		u32 bitfield;
+/*100*/	const
+/*170*/	struct { /* In Service Register */
+		u32 bitfield;
 		u32 __reserved[3];
 	} isr [8];

-/*180*/	struct { /* Trigger Mode Register */
-/*1F0*/		u32 bitfield;
+/*180*/	const
+/*1F0*/	struct { /* Trigger Mode Register */
+		u32 bitfield;
 		u32 __reserved[3];
 	} tmr [8];

-/*200*/	struct { /* Interrupt Request Register */
-/*270*/		u32 bitfield;
+/*200*/	const
+/*270*/	struct { /* Interrupt Request Register */
+		u32 bitfield;
 		u32 __reserved[3];
 	} irr [8];

-/*280*/	union { /* Error Status Register */
+/*280*/	const
+	union { /* Error Status Register */
 		struct {
-			u32   send_cs_error			:  1,
-				receive_cs_error		:  1,
-				send_accept_error		:  1,
-				receive_accept_error		:  1,
-				__reserved_1			:  1,
-				send_illegal_vector		:  1,
-				receive_illegal_vector		:  1,
-				illegal_register_address	:  1,
-				__reserved_2			: 24;
+			u32   send_cs_error:1,
+				receive_cs_error:1,
+				send_accept_error:1,
+				receive_accept_error:1,
+				__reserved_1:1,
+				send_illegal_vector:1,
+				receive_illegal_vector:1,
+				illegal_register_address:1,
+				__reserved_2:24;
 			u32 __reserved_3[3];
 		} error_bits;
 		struct {
@@ -289,96 +293,96 @@ struct local_apic {
 /*2F0*/	struct { u32 __reserved[4]; } __reserved_14;

 /*300*/	struct { /* Interrupt Command Register 1 */
-		u32   vector			:  8,
-			delivery_mode		:  3,
-			destination_mode	:  1,
-			delivery_status		:  1,
-			__reserved_1		:  1,
-			level			:  1,
-			trigger			:  1,
-			__reserved_2		:  2,
-			shorthand		:  2,
-			__reserved_3		:  12;
+		u32   vector:8,
+			delivery_mode:3,
+			destination_mode:1,
+			delivery_status:1,
+			__reserved_1:1,
+			level:1,
+			trigger:1,
+			__reserved_2:2,
+			shorthand:2,
+			__reserved_3:12;
 		u32 __reserved_4[3];
 	} icr1;

 /*310*/	struct { /* Interrupt Command Register 2 */
 		union {
-			u32   __reserved_1	: 24,
-				phys_dest	:  4,
-				__reserved_2	:  4;
-			u32   __reserved_3	: 24,
-				logical_dest	:  8;
+			u32   __reserved_1:24,
+				phys_dest:4,
+				__reserved_2:4;
+			u32   __reserved_3:24,
+				logical_dest:8;
 		} dest;
 		u32 __reserved_4[3];
 	} icr2;

 /*320*/	struct { /* LVT - Timer */
-		u32   vector		:  8,
-			__reserved_1	:  4,
-			delivery_status	:  1,
-			__reserved_2	:  3,
-			mask		:  1,
-			timer_mode	:  1,
-			__reserved_3	: 14;
+		u32   vector:8,
+			__reserved_1:4,
+			delivery_status:1,
+			__reserved_2:3,
+			mask:1,
+			timer_mode:1,
+			__reserved_3:14;
 		u32 __reserved_4[3];
 	} lvt_timer;

 /*330*/	struct { /* LVT - Thermal Sensor */
-		u32  vector		:  8,
-			delivery_mode	:  3,
-			__reserved_1	:  1,
-			delivery_status	:  1,
-			__reserved_2	:  3,
-			mask		:  1,
-			__reserved_3	: 15;
+		u32  vector:8,
+			delivery_mode:3,
+			__reserved_1:1,
+			delivery_status:1,
+			__reserved_2:3,
+			mask:1,
+			__reserved_3:15;
 		u32 __reserved_4[3];
 	} lvt_thermal;

 /*340*/	struct { /* LVT - Performance Counter */
-		u32   vector		:  8,
-			delivery_mode	:  3,
-			__reserved_1	:  1,
-			delivery_status	:  1,
-			__reserved_2	:  3,
-			mask		:  1,
-			__reserved_3	: 15;
+		u32   vector:8,
+			delivery_mode:3,
+			__reserved_1:1,
+			delivery_status:1,
+			__reserved_2:3,
+			mask:1,
+			__reserved_3:15;
 		u32 __reserved_4[3];
 	} lvt_pc;

 /*350*/	struct { /* LVT - LINT0 */
-		u32   vector		:  8,
-			delivery_mode	:  3,
-			__reserved_1	:  1,
-			delivery_status	:  1,
-			polarity	:  1,
-			remote_irr	:  1,
-			trigger		:  1,
-			mask		:  1,
-			__reserved_2	: 15;
+		u32   vector:8,
+			delivery_mode:3,
+			__reserved_1:1,
+			delivery_status:1,
+			polarity:1,
+			remote_irr:1,
+			trigger:1,
+			mask:1,
+			__reserved_2:15;
 		u32 __reserved_3[3];
 	} lvt_lint0;

 /*360*/	struct { /* LVT - LINT1 */
-		u32   vector		:  8,
-			delivery_mode	:  3,
-			__reserved_1	:  1,
-			delivery_status	:  1,
-			polarity	:  1,
-			remote_irr	:  1,
-			trigger		:  1,
-			mask		:  1,
-			__reserved_2	: 15;
+		u32   vector:8,
+			delivery_mode:3,
+			__reserved_1:1,
+			delivery_status:1,
+			polarity:1,
+			remote_irr:1,
+			trigger:1,
+			mask:1,
+			__reserved_2:15;
 		u32 __reserved_3[3];
 	} lvt_lint1;

 /*370*/	struct { /* LVT - Error */
-		u32   vector		:  8,
-			__reserved_1	:  4,
-			delivery_status	:  1,
-			__reserved_2	:  3,
-			mask		:  1,
-			__reserved_3	: 15;
+		u32   vector:8,
+			__reserved_1:4,
+			delivery_status:1,
+			__reserved_2:3,
+			mask:1,
+			__reserved_3:15;
 		u32 __reserved_4[3];
 	} lvt_error;

@@ -402,8 +406,8 @@ struct local_apic {
 /*3D0*/	struct { u32 __reserved[4]; } __reserved_19;

 /*3E0*/	struct { /* Timer Divide Configuration Register */
-		u32   divisor		:  4,
-			__reserved_1	: 28;
+		u32   divisor:4,
+			__reserved_1:28;
 		u32 __reserved_2[3];
 	} timer_dcr;
