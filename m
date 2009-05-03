Return-Path: <linux-kernel-owner+w=401wt.eu-S1751853AbZECFmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbZECFmk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 01:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZECFm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 01:42:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:47634 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbZECFm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 01:42:28 -0400
Subject: [PATCH -tip] x86: cpufeature.h fix name for X86_FEATURE_MCE
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 03 May 2009 11:11:35 +0530
Message-Id: <1241329295.6321.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


X86_FEATURE_MCE = Machine Check Exception
X86_FEATURE_MCA = Machine Check Architecture

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpufeature.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index bb83b1c..ccc1061 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -22,7 +22,7 @@
 #define X86_FEATURE_TSC		(0*32+ 4) /* Time Stamp Counter */
 #define X86_FEATURE_MSR		(0*32+ 5) /* Model-Specific Registers */
 #define X86_FEATURE_PAE		(0*32+ 6) /* Physical Address Extensions */
-#define X86_FEATURE_MCE		(0*32+ 7) /* Machine Check Architecture */
+#define X86_FEATURE_MCE		(0*32+ 7) /* Machine Check Exception */
 #define X86_FEATURE_CX8		(0*32+ 8) /* CMPXCHG8 instruction */
 #define X86_FEATURE_APIC	(0*32+ 9) /* Onboard APIC */
 #define X86_FEATURE_SEP		(0*32+11) /* SYSENTER/SYSEXIT */
-- 
1.6.0.6



