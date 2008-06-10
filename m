Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbYFJBFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbYFJBFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 21:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbYFJBFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 21:05:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:40571 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbYFJBFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 21:05:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,615,1204531200"; 
   d="scan'208";a="392776074"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Subject: RE: [patch]modify the MIPS CPU classfication
Date: Tue, 10 Jun 2008 09:05:08 +0800
Message-ID: <42DFA526FC41B1429CE7279EF83C6BDC01404431@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <Pine.LNX.4.55.0806091330560.26593@cliff.in.clinika.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch]modify the MIPS CPU classfication
Thread-Index: AcjKLQ3t3yNX5I2dSn6iZ6hMyMZZswAaL/6g
References: <42DFA526FC41B1429CE7279EF83C6BDC01404341@pdsmsx415.ccr.corp.intel.com> <Pine.LNX.4.55.0806091330560.26593@cliff.in.clinika.pl>
From: "Chen, Huacai" <huacai.chen@intel.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Jun 2008 01:05:05.0973 (UTC) FILETIME=[051CAE50:01C8CA96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the new patch sorted numerically.

Signed-off-by: Huacai Chen <huacai.chen@intel.com>

----
diff --git a/include/asm-mips/cpu.h b/include/asm-mips/cpu.h
index 1c35cac..229a786 100644
--- a/include/asm-mips/cpu.h
+++ b/include/asm-mips/cpu.h
@@ -66,8 +66,10 @@
 #define PRID_IMP_RM7000		0x2700
 #define PRID_IMP_NEVADA		0x2800		/* RM5260 ??? */
 #define PRID_IMP_RM9000		0x3400
+#define PRID_IMP_LOONGSON1	0x4200
 #define PRID_IMP_R5432		0x5400
 #define PRID_IMP_R5500		0x5500
+#define PRID_IMP_LOONGSON2	0x6300
 
 #define PRID_IMP_UNKNOWN	0xff00
 
@@ -90,8 +92,6 @@
 #define PRID_IMP_24KE		0x9600
 #define PRID_IMP_74K		0x9700
 #define PRID_IMP_1004K		0x9900
-#define PRID_IMP_LOONGSON1      0x4200
-#define PRID_IMP_LOONGSON2      0x6300
 
 /*
  * These are the PRID's for when 23:16 == PRID_COMP_SIBYTE
----

-----Original Message-----
From: macro@cliff.in.clinika.pl [mailto:macro@cliff.in.clinika.pl] On Behalf Of Maciej W. Rozycki
Sent: 2008年6月9日 20:33
To: Chen, Huacai
Cc: linux-mips@linux-mips.org; linux-kernel@vger.kernel.org
Subject: Re: [patch]modify the MIPS CPU classfication

On Mon, 9 Jun 2008, Chen, Huacai wrote:

> The company ID of Loongson1/Loongson2 is PRID_COMP_LEGACY, but they were
> classified in the list whoes company ID is  PRID_COMP_MIPS. This patch
> move them to the right place.

 Note the list is currently sorted numerically and meant to stay such.  
Please update your patch accordingly.

  Maciej
