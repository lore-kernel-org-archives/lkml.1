Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbZA1Xys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbZA1Xys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757821AbZA1XoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:37519 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898AbZA1XoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:15 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 028/114] x86, apic: remove IRQ_DEST_MODE
Date: Wed, 28 Jan 2009 23:41:34 +0000
Message-Id: <1233186180-29883-29-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove leftover definition.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/mach-default/mach_apic.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index f3b2cd4..ce3bc48 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -22,7 +22,6 @@ static inline const struct cpumask *target_cpus(void)
 
 #ifdef CONFIG_X86_64
 #include <asm/genapic.h>
-#define IRQ_DEST_MODE (apic->irq_dest_mode)
 #define TARGET_CPUS	  (apic->target_cpus())
 #define init_apic_ldr (apic->init_apic_ldr)
 #define cpu_mask_to_apicid (apic->cpu_mask_to_apicid)
-- 
1.6.0.2

