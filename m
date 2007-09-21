Return-Path: <linux-kernel-owner+w=401wt.eu-S1764224AbXIUUtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764224AbXIUUtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763304AbXIUUpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:32967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763185AbXIUUo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:44:58 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: eranian@hpl.hp.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [15/45] i386: i386 add AMD64 Barcelona PMU MSR definitions to msr.h
Message-Id: <20070921204456.D1DBA14EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:44:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Stephane Eranian <eranian@hpl.hp.com>

[i386] add AMD Barcelona PMU MSR definitions

AK: Not used right now, but will presumably at some point.
    
Signed-off-by: Stephane Eranian <eranian@hpl.hp.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-i386/msr-index.h |   36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

Index: linux/include/asm-i386/msr-index.h
===================================================================
--- linux.orig/include/asm-i386/msr-index.h
+++ linux/include/asm-i386/msr-index.h
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
