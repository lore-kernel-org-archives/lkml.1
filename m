Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbXKFSsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbXKFSsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbXKFSsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:48:21 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:20321 "EHLO
	mail108-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbXKFSsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:48:20 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Message-ID: <20071106183646.064906000@amd.com>
References: <20071106183645.951275000@amd.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 19:36:46 +0100
From: "Robert Richter" <robert.richter@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
cc: "Robert Richter" <robert.richter@amd.com>
Subject: [patch 1/6] x86: apicdef unification: some constants made
 unsigned
X-OriginalArrivalTime: 06 Nov 2007 18:47:57.0855 (UTC)
 FILETIME=[8C79E2F0:01C820A5]
MIME-Version: 1.0
X-WSS-ID: 6B2E696B24S1590817-01-01
Content-Disposition: inline;
 filename="apicdef/0001-apicdef_32.h-some-constants-made-unsigned.patch"
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 include/asm-x86/apicdef_32.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

Index: linux-perfmon/include/asm-x86/apicdef_32.h
===================================================================
--- linux-perfmon.orig/include/asm-x86/apicdef_32.h
+++ linux-perfmon/include/asm-x86/apicdef_32.h
@@ -13,23 +13,23 @@
 #define		APIC_ID		0x20
 #define		APIC_LVR	0x30
 #define			APIC_LVR_MASK		0xFF00FF
-#define			GET_APIC_VERSION(x)	((x)&0xFF)
-#define			GET_APIC_MAXLVT(x)	(((x)>>16)&0xFF)
-#define			APIC_INTEGRATED(x)	((x)&0xF0)
+#define			GET_APIC_VERSION(x)	((x)&0xFFu)
+#define			GET_APIC_MAXLVT(x)	(((x)>>16)&0xFFu)
+#define			APIC_INTEGRATED(x)	((x)&0xF0u)
 #define			APIC_XAPIC(x)		((x) >= 0x14)
 #define		APIC_TASKPRI	0x80
-#define			APIC_TPRI_MASK		0xFF
+#define			APIC_TPRI_MASK		0xFFu
 #define		APIC_ARBPRI	0x90
-#define			APIC_ARBPRI_MASK	0xFF
+#define			APIC_ARBPRI_MASK	0xFFu
 #define		APIC_PROCPRI	0xA0
 #define		APIC_EOI	0xB0
 #define			APIC_EIO_ACK		0x0		/* Write this to the EOI register */
 #define		APIC_RRR	0xC0
 #define		APIC_LDR	0xD0
-#define			APIC_LDR_MASK		(0xFF<<24)
-#define			GET_APIC_LOGICAL_ID(x)	(((x)>>24)&0xFF)
+#define			APIC_LDR_MASK		(0xFFu<<24)
+#define			GET_APIC_LOGICAL_ID(x)	(((x)>>24)&0xFFu)
 #define			SET_APIC_LOGICAL_ID(x)	(((x)<<24))
-#define			APIC_ALL_CPUS		0xFF
+#define			APIC_ALL_CPUS		0xFFu
 #define		APIC_DFR	0xE0
 #define			APIC_DFR_CLUSTER		0x0FFFFFFFul
 #define			APIC_DFR_FLAT			0xFFFFFFFFul

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com



