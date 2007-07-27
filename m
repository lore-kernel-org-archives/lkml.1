Return-Path: <linux-kernel-owner+w=401wt.eu-S964802AbXG0OGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964802AbXG0OGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 10:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760562AbXG0OGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 10:06:43 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:62307 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760036AbXG0OGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 10:06:42 -0400
Date: Fri, 27 Jul 2007 07:06:21 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, akpm@linux-foundation.org, robert.richter@amd.com,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: [PATCH] i386 add AMD64 Barcelona PMU MSR definitions
Message-ID: <20070727140621.GH9828@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[Repost due to typos in the linux-kernel email address, sorry about that]

    [i386] add AMD Barcelona PMU MSR definitions
    
    signed-off-by: Stephane Eranian <eranian@hpl.hp.com>
    signed-off-by: Robert Richter <robert.richter@amd.com>

diff --git a/include/asm-i386/msr-index.h b/include/asm-i386/msr-index.h
index a02eb29..a494473 100644
--- a/include/asm-i386/msr-index.h
+++ b/include/asm-i386/msr-index.h
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

-Stephane
