Return-Path: <linux-kernel-owner+w=401wt.eu-S1758531AbYFXKb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbYFXKb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 06:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbYFXKbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 06:31:17 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:5382 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbYFXKbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 06:31:16 -0400
X-BigFish: VPS24(zzzz10d3izzz32i87il43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K2YQJR-02-RPX-01
From: Robert Richter <robert.richter@amd.com>
Subject: [PATCH] x86: Add X86_FEATURE_IBS cpu feature
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Message-ID: <20080624103105.3068980E7@erda.amd.com>
Date: Tue, 24 Jun 2008 12:31:05 +0200
X-OriginalArrivalTime: 24 Jun 2008 10:31:05.0353 (UTC) FILETIME=[68435790:01C8D5E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds IBS to the cpu feature flags allowing Perfmon and OProfile
to use cpu_has().

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 include/asm-x86/cpufeature.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/cpufeature.h b/include/asm-x86/cpufeature.h
index 0d609c8..e2469a7 100644
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -106,6 +106,7 @@
 /* More extended AMD flags: CPUID level 0x80000001, ecx, word 6 */
 #define X86_FEATURE_LAHF_LM	(6*32+ 0) /* LAHF/SAHF in long mode */
 #define X86_FEATURE_CMP_LEGACY	(6*32+ 1) /* If yes HyperThreading not valid */
+#define X86_FEATURE_IBS		(6*32+ 10) /* Instruction Based Sampling */
 
 /*
  * Auxiliary flags: Linux defined - For features scattered in various
-- 
1.5.5.3


