Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYG2PoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYG2PoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 11:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYG2PoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 11:44:00 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:17964 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbYG2PoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 11:44:00 -0400
X-BigFish: VPS7(zz1cddkzz10d3izzz32i43j67h)
X-Spam-TCS-SCL: 6:0
X-FB-SS: 5,
X-WSS-ID: 0K4RYCW-01-3JK-01
Message-ID: <20080729154145.645238335@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Tue, 29 Jul 2008 17:41:05 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Peter Oruba <peter.oruba@amd.com>
Subject: [patch 2/4] x86: Intel microcode patch loader style corrections.
References: <20080729154103.007575982@amd.com>
Content-Disposition: inline;
	filename="0002-x86-Intel-microcode-patch-loader-style-corrections.patch"
X-OriginalArrivalTime: 29 Jul 2008 15:43:49.0150 (UTC) FILETIME=[E4D0CBE0:01C8F191]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 arch/x86/kernel/microcode_intel.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 6da4a85..a61986e 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -55,8 +55,8 @@
  *		in a single CPU package.
  *	1.10	28 Feb 2002 Asit K Mallick <asit.k.mallick@intel.com> and
  *		Tigran Aivazian <tigran@veritas.com>,
- *		Serialize updates as required on HT processors due to speculative
- *		nature of implementation.
+ *		Serialize updates as required on HT processors due to
+ *		speculative nature of implementation.
  *	1.11	22 Mar 2002 Tigran Aivazian <tigran@veritas.com>
  *		Fix the panic when writing zero-length microcode chunk.
  *	1.12	29 Sep 2003 Nitin Kamble <nitin.a.kamble@intel.com>,
@@ -71,7 +71,7 @@
  *		Thanks to Stuart Swales for pointing out this bug.
  */
 
-//#define DEBUG /* pr_debug */
+/* #define DEBUG */ /* pr_debug */
 #include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -99,11 +99,11 @@ MODULE_DESCRIPTION("Microcode Update Driver");
 MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
 MODULE_LICENSE("GPL");
 
-#define DEFAULT_UCODE_DATASIZE 	(2000) 	  /* 2000 bytes */
-#define MC_HEADER_SIZE		(sizeof(struct microcode_header_intel)) /* 48 bytes */
-#define DEFAULT_UCODE_TOTALSIZE (DEFAULT_UCODE_DATASIZE + MC_HEADER_SIZE) /* 2048 bytes */
-#define EXT_HEADER_SIZE		(sizeof(struct extended_sigtable)) /* 20 bytes */
-#define EXT_SIGNATURE_SIZE	(sizeof(struct extended_signature)) /* 12 bytes */
+#define DEFAULT_UCODE_DATASIZE 	(2000)
+#define MC_HEADER_SIZE		(sizeof(struct microcode_header_intel))
+#define DEFAULT_UCODE_TOTALSIZE (DEFAULT_UCODE_DATASIZE + MC_HEADER_SIZE)
+#define EXT_HEADER_SIZE		(sizeof(struct extended_sigtable))
+#define EXT_SIGNATURE_SIZE	(sizeof(struct extended_signature))
 #define DWSIZE			(sizeof(u32))
 #define get_totalsize(mc) \
 	(((struct microcode_intel *)mc)->hdr.totalsize ? \
-- 
1.5.4.5




