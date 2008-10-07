Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbYJGUdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbYJGUdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbYJGUdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:33:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:58115 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734AbYJGUdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:33:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,375,1220252400"; 
   d="scan'208";a="388731877"
Date: Tue, 7 Oct 2008 13:33:12 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/tip: AMDC1E and XTOPOLOGY conflict in cpufeature
Message-ID: <20081007203311.GA31189@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix two features from conflicting in feature bits. Looks like the conflict
came from automatic conflict resolution?

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 include/asm-x86/cpufeature.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip/include/asm-x86/cpufeature.h
===================================================================
--- tip.orig/include/asm-x86/cpufeature.h	2008-10-07 13:04:01.000000000 -0700
+++ tip/include/asm-x86/cpufeature.h	2008-10-07 13:05:51.000000000 -0700
@@ -90,7 +90,7 @@
 #define X86_FEATURE_11AP	(3*32+19) /* "" Bad local APIC aka 11AP */
 #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
 #define X86_FEATURE_AMDC1E	(3*32+21) /* AMD C1E detected */
-#define X86_FEATURE_XTOPOLOGY	(3*32+21) /* cpu topology enum extensions */
+#define X86_FEATURE_XTOPOLOGY	(3*32+22) /* cpu topology enum extensions */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
