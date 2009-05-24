Return-Path: <linux-kernel-owner+w=401wt.eu-S1759580AbZEXP7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580AbZEXP7s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758693AbZEXPyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:54:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41836 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274AbZEXPud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:33 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 20/45] x86: Add cpu features MOVBE and POPCNT
Date: Sun, 24 May 2009 18:50:05 +0300
Message-Id: <1243180230-2480-21-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cpu feature bit support for the MOVBE and POPCNT instructions.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/cpufeature.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index bb83b1c..9c63bf3 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -115,6 +115,8 @@
 #define X86_FEATURE_XMM4_1	(4*32+19) /* "sse4_1" SSE-4.1 */
 #define X86_FEATURE_XMM4_2	(4*32+20) /* "sse4_2" SSE-4.2 */
 #define X86_FEATURE_X2APIC	(4*32+21) /* x2APIC */
+#define X86_FEATURE_MOVBE	(4*32+22) /* MOVBE instruction */
+#define X86_FEATURE_POPCNT      (4*32+23) /* POPCNT instruction */
 #define X86_FEATURE_AES		(4*32+25) /* AES instructions */
 #define X86_FEATURE_XSAVE	(4*32+26) /* XSAVE/XRSTOR/XSETBV/XGETBV */
 #define X86_FEATURE_OSXSAVE	(4*32+27) /* "" XSAVE enabled in the OS */
-- 
1.6.0.6

