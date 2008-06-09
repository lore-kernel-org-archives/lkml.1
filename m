Return-Path: <linux-kernel-owner+w=401wt.eu-S1761090AbYFILQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761090AbYFILQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 07:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760939AbYFILP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 07:15:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:49748 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbYFILP6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 07:15:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,612,1204531200"; 
   d="scan'208";a="337992158"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: [patch]modify the MIPS CPU classfication
Date: Mon, 9 Jun 2008 19:15:58 +0800
Message-ID: <42DFA526FC41B1429CE7279EF83C6BDC01404341@pdsmsx415.ccr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch]modify the MIPS CPU classfication
Thread-Index: AcjKIjEbexxBO5k+To62Keu79ukJrg==
From: "Chen, Huacai" <huacai.chen@intel.com>
To: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 09 Jun 2008 11:15:54.0822 (UTC) FILETIME=[2F1D7E60:01C8CA22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The company ID of Loongson1/Loongson2 is PRID_COMP_LEGACY, but they were
classified in the list whoes company ID is  PRID_COMP_MIPS. This patch
move them to the right place.

Signed-off-by: Huacai Chen <huacai.chen@intel.com>

-----
diff --git a/include/asm-mips/cpu.h b/include/asm-mips/cpu.h
index 1c35cac..d3ffe93 100644
--- a/include/asm-mips/cpu.h
+++ b/include/asm-mips/cpu.h
@@ -68,6 +68,8 @@
 #define PRID_IMP_RM9000        0x3400
 #define PRID_IMP_R5432     0x5400
 #define PRID_IMP_R5500     0x5500
+#define PRID_IMP_LOONGSON1      0x4200
+#define PRID_IMP_LOONGSON2      0x6300

 #define PRID_IMP_UNKNOWN   0xff00

@@ -90,8 +92,6 @@
 #define PRID_IMP_24KE      0x9600
 #define PRID_IMP_74K       0x9700
 #define PRID_IMP_1004K     0x9900
-#define PRID_IMP_LOONGSON1      0x4200
-#define PRID_IMP_LOONGSON2      0x6300

 /*
  * These are the PRID's for when 23:16 == PRID_COMP_SIBYTE
-----
