Return-Path: <linux-kernel-owner+w=401wt.eu-S1752356AbZGAMUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbZGAMUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbZGAMUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 08:20:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:35187 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbZGAMUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 08:20:08 -0400
Subject: [PATCH -tip RESEND] x86: msr-index.h remove double declaration of
 MSR_P6_EVNTSEL0 and MSR_P6_EVNTSEL1
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 17:49:38 +0530
Message-Id: <1246450778.6940.8.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


MSR_P6_EVNTSEL0 and MSR_P6_EVNTSEL1 is already declared in msr-index.h.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/msr-index.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 4d58d04..35ec37a 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -239,10 +239,6 @@
 #define MSR_IA32_MISC_ENABLE_TURBO_DISABLE	(1ULL << 38)
 #define MSR_IA32_MISC_ENABLE_IP_PREF_DISABLE	(1ULL << 39)
 
-/* Intel Model 6 */
-#define MSR_P6_EVNTSEL0			0x00000186
-#define MSR_P6_EVNTSEL1			0x00000187
-
 /* P4/Xeon+ specific */
 #define MSR_IA32_MCG_EAX		0x00000180
 #define MSR_IA32_MCG_EBX		0x00000181
-- 
1.6.0.6



