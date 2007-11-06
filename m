Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbXKFSu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbXKFSu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbXKFSut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:50:49 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:63154 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753917AbXKFSus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:50:48 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Message-ID: <20071106183646.534316000@amd.com>
References: <20071106183645.951275000@amd.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 19:36:51 +0100
From: "Robert Richter" <robert.richter@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
cc: "Robert Richter" <robert.richter@amd.com>
Subject: [patch 6/6] x86: apicdef unification: more whitespace changes
X-OriginalArrivalTime: 06 Nov 2007 18:47:58.0042 (UTC)
 FILETIME=[8C966BA0:01C820A5]
MIME-Version: 1.0
X-WSS-ID: 6B2E696E07S1612541-08-01
Content-Disposition: inline;
 filename="apicdef/0006-apicdef-more-whitespace-changes.patch"
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 include/asm-x86/apicdef.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-perfmon/include/asm-x86/apicdef.h
===================================================================
--- linux-perfmon.orig/include/asm-x86/apicdef.h
+++ linux-perfmon/include/asm-x86/apicdef.h
@@ -9,7 +9,7 @@
  */
 
 #define		APIC_DEFAULT_PHYS_BASE	0xfee00000
- 
+
 #define		APIC_ID		0x20
 #ifndef CONFIG_X86_32
 #define			APIC_ID_MASK		(0xFFu<<24)
@@ -46,8 +46,8 @@
 #define		APIC_ISR	0x100
 #define		APIC_ISR_NR	0x8	/* Number of 32 bit ISR registers. */
 #define		APIC_TMR	0x180
-#define 	APIC_IRR	0x200
-#define 	APIC_ESR	0x280
+#define		APIC_IRR	0x200
+#define		APIC_ESR	0x280
 #define			APIC_ESR_SEND_CS	0x00001
 #define			APIC_ESR_RECV_CS	0x00002
 #define			APIC_ESR_SEND_ACC	0x00004
@@ -100,11 +100,11 @@
 #define			APIC_SEND_PENDING		(1<<12)
 #define			APIC_MODE_MASK			0x700
 #define			GET_APIC_DELIVERY_MODE(x)	(((x)>>8)&0x7)
-#define			SET_APIC_DELIVERY_MODE(x,y)	(((x)&~0x700)|((y)<<8))
+#define			SET_APIC_DELIVERY_MODE(x, y)	(((x)&~0x700)|((y)<<8))
 #define				APIC_MODE_FIXED		0x0
 #define				APIC_MODE_NMI		0x4
 #define				APIC_MODE_EXTINT	0x7
-#define 	APIC_LVT1	0x360
+#define		APIC_LVT1	0x360
 #define		APIC_LVTERR	0x370
 #define		APIC_TMICT	0x380
 #define		APIC_TMCCT	0x390

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com



