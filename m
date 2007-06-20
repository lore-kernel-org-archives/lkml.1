Return-Path: <linux-kernel-owner+w=401wt.eu-S1763759AbXFTSrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763759AbXFTSrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762282AbXFTSl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:41:58 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:20217 "EHLO
	outbound2-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762465AbXFTSl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:41:57 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Wed, 20 Jun 2007 20:41:37 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Stephane Eranian" <eranian@hpl.hp.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "David Rientjes" <rientjes@google.com>
cc: linux-kernel@vger.kernel.org, "Robert Richter" <robert.richter@amd.com>
Subject: [patch 4/8] 2.6.22-rc3 perfmon2 : Rearrangement of AMD64 MSR
 definitions, 2nd try
Message-ID: <20070620184137.GE5874@erda.amd.com>
References: <20070620182126.248753000@amd.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 20 Jun 2007 18:41:37.0409 (UTC)
 FILETIME=[A24B2F10:01C7B36A]
X-WSS-ID: 6A67AB6E1S4957735-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline;
 filename=perfmon2-fam10h-004.diff
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

hex values are now lowercase, thanks. This also affects patch #6.

Andi,

since this is not a Perfmon specific patch, could you apply it?

Thanks,
-Robert

---------------

This patch rearranges AMD64 MSR definitions.

2nd try:
- hex values made lowercase

Signed-off-by: Robert Richter <robert.richter@amd.com>

Index: linux-2.6.22-rc3/include/asm-i386/msr-index.h
===================================================================
--- linux-2.6.22-rc3.orig/include/asm-i386/msr-index.h
+++ linux-2.6.22-rc3/include/asm-i386/msr-index.h
@@ -75,6 +75,18 @@
 
 /* K7/K8 MSRs. Not complete. See the architecture manual for a more
    complete list. */
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
@@ -83,20 +95,10 @@
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



