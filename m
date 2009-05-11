Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbZEKRDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbZEKRDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756915AbZEKRB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:01:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:43740 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757948AbZEKRB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:01:26 -0400
Subject: [PATCH 13/15 -tip] x86: Add cpufeature for Bus configuration
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1242060812.5139.22.camel@ht.satnam>
References: <1242058494.5139.7.camel@ht.satnam>
	 <1242060119.5139.9.camel@ht.satnam>  <1242060207.5139.11.camel@ht.satnam>
	 <1242060254.5139.12.camel@ht.satnam>  <1242060301.5139.13.camel@ht.satnam>
	 <1242060523.5139.15.camel@ht.satnam>  <1242060567.5139.16.camel@ht.satnam>
	 <1242060601.5139.17.camel@ht.satnam>  <1242060644.5139.18.camel@ht.satnam>
	 <1242060681.5139.19.camel@ht.satnam>  <1242060721.5139.20.camel@ht.satnam>
	 <1242060771.5139.21.camel@ht.satnam>  <1242060812.5139.22.camel@ht.satnam>
Content-Type: text/plain
Date: Mon, 11 May 2009 22:24:18 +0530
Message-Id: <1242060858.5139.23.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


X86_FEATURE_BUS_CFG : MSRC001_1023 Bus Unit Configuration Register (BU_CFG)

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/amd.c         |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 101d8de..aee0978 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -167,6 +167,7 @@
 #define X86_FEATURE_SYS_CFG 	(7*32+ 12) /* System configuration	*/
 #define X86_FEATURE_SMM 	(7*32+ 13) /* System Management	Mode	*/
 #define X86_FEATURE_MM_CFG 	(7*32+ 14) /* MM configuration		*/
+#define X86_FEATURE_BUS_CFG 	(7*32+ 15) /* Bus configuration		*/
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index d068044..4b7f7dc 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -497,6 +497,8 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		set_cpu_cap(c, X86_FEATURE_CACHE_CTL);
 		/* MSRC001_0058 MMIO Configuration Base Address Register*/
 		set_cpu_cap(c, X86_FEATURE_MM_CFG);
+		/* MSRC001_1023 Bus Unit Configuration Register (BU_CFG)*/
+		set_cpu_cap(c, X86_FEATURE_BUS_CFG);
 	}
 }
 
-- 
1.6.0.6



