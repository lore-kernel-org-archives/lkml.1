Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbXICIUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbXICIUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 04:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbXICITz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 04:19:55 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:31817 "EHLO
	outbound7-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754925AbXICITy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 04:19:54 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Message-ID: <20070903081736.407098000@amd.com>
References: <20070903081736.288288000@amd.com>
User-Agent: quilt/0.46-1
Date: Mon, 03 Sep 2007 10:17:37 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: patches@x86-64.org, linux-kernel@vger.kernel.org,
       "Robert Richter" <robert.richter@amd.com>
Subject: [patch 1/5] x86: Add AMD64 Barcelona PMU MSR definitions
X-OriginalArrivalTime: 03 Sep 2007 08:18:31.0589 (UTC)
 FILETIME=[03970550:01C7EE03]
MIME-Version: 1.0
X-WSS-ID: 6AC51C121A46452967-11-01
Content-Disposition: inline;
 filename=i386-add-amd64-barcelona-pmu-msr-definitions.patch
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Already added to the -mm tree.  Its filename is
     i386-add-amd64-barcelona-pmu-msr-definitions.patch

Signed-off-by: Robert Richter <robert.richter@amd.com>

---
 include/asm-i386/msr-index.h |   36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

Index: linux-2.6/include/asm-i386/msr-index.h
===================================================================
--- linux-2.6.orig/include/asm-i386/msr-index.h
+++ linux-2.6/include/asm-i386/msr-index.h
@@ -73,8 +73,32 @@
 #define MSR_P6_EVNTSEL0			0x00000186
 #define MSR_P6_EVNTSEL1			0x00000187
 
-/* K7/K8 MSRs. Not complete. See the architecture manual for a more
+/* AMD64 MSRs. Not complete. See the architecture manual for a more
    complete list. */
+
+#define MSR_AMD64_IBSFETCHCTL		0xc0011030
+#define MSR_AMD64_IBSFETCHLINAD		0xc0011031
+#define MSR_AMD64_IBSFETCHPHYSAD	0xc0011032
+#define MSR_AMD64_IBSOPCTL		0xc0011033
+#define MSR_AMD64_IBSOPRIP		0xc0011034
+#define MSR_AMD64_IBSOPDATA		0xc0011035
+#define MSR_AMD64_IBSOPDATA2		0xc0011036
+#define MSR_AMD64_IBSOPDATA3		0xc0011037
+#define MSR_AMD64_IBSDCLINAD		0xc0011038
+#define MSR_AMD64_IBSDCPHYSAD		0xc0011039
+#define MSR_AMD64_IBSCTL		0xc001103a
+
+/* K8 MSRs */
+#define MSR_K8_TOP_MEM1			0xc001001a
+#define MSR_K8_TOP_MEM2			0xc001001d
+#define MSR_K8_SYSCFG			0xc0010010
+#define MSR_K8_HWCR			0xc0010015
+#define MSR_K8_ENABLE_C1E		0xc0010055
+#define K8_MTRRFIXRANGE_DRAM_ENABLE	0x00040000 /* MtrrFixDramEn bit    */
+#define K8_MTRRFIXRANGE_DRAM_MODIFY	0x00080000 /* MtrrFixDramModEn bit */
+#define K8_MTRR_RDMEM_WRMEM_MASK	0x18181818 /* Mask: RdMem|WrMem    */
+
+/* K7 MSRs */
 #define MSR_K7_EVNTSEL0			0xc0010000
 #define MSR_K7_PERFCTR0			0xc0010004
 #define MSR_K7_EVNTSEL1			0xc0010001
@@ -83,20 +107,10 @@
 #define MSR_K7_PERFCTR2			0xc0010006
 #define MSR_K7_EVNTSEL3			0xc0010003
 #define MSR_K7_PERFCTR3			0xc0010007
-#define MSR_K8_TOP_MEM1			0xc001001a
 #define MSR_K7_CLK_CTL			0xc001001b
-#define MSR_K8_TOP_MEM2			0xc001001d
-#define MSR_K8_SYSCFG			0xc0010010
-
-#define K8_MTRRFIXRANGE_DRAM_ENABLE	0x00040000 /* MtrrFixDramEn bit    */
-#define K8_MTRRFIXRANGE_DRAM_MODIFY	0x00080000 /* MtrrFixDramModEn bit */
-#define K8_MTRR_RDMEM_WRMEM_MASK	0x18181818 /* Mask: RdMem|WrMem    */
-
 #define MSR_K7_HWCR			0xc0010015
-#define MSR_K8_HWCR			0xc0010015
 #define MSR_K7_FID_VID_CTL		0xc0010041
 #define MSR_K7_FID_VID_STATUS		0xc0010042
-#define MSR_K8_ENABLE_C1E		0xc0010055
 
 /* K6 MSRs */
 #define MSR_K6_EFER			0xc0000080

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com



