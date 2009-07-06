Return-Path: <linux-kernel-owner+w=401wt.eu-S1757692AbZGFJN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692AbZGFJN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 05:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZGFJNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 05:13:49 -0400
Received: from mail.atmel.fr ([81.80.104.162]:32878 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbZGFJNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 05:13:48 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.arm.linux.org.uk, haavard.skinnemoen@atmel.com,
       kernel@avr32linux.org
Cc: patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
       nicolas.ferre@atmel.com
Subject: [PATCH] avr32: add two new at91 to cpu.h definition
Date: Mon,  6 Jul 2009 12:15:12 +0200
Message-Id: <1246875312-6824-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somme common drivers will need those at91 cpu_is_xxx() definitions. As
at91sam9g10 and at91sam9g45 are on the way to linus' tree, here is the patch
that adds those chips to cpu.h in AVR32 architecture.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Inclusion in linux-2.6-arm.git/devel:

at91sam9g10: b784b7c03723891876c9053c589150a4062f9455
at91sam9g45: fddcc0ae58edefeb7ac1e460411d7dfbe8ebdacc


 arch/avr32/mach-at32ap/include/mach/cpu.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/mach-at32ap/include/mach/cpu.h b/arch/avr32/mach-at32ap/include/mach/cpu.h
index 44d0bfa..c253e9b 100644
--- a/arch/avr32/mach-at32ap/include/mach/cpu.h
+++ b/arch/avr32/mach-at32ap/include/mach/cpu.h
@@ -31,5 +31,7 @@
 #define cpu_is_at91sam9263()	(0)
 #define cpu_is_at91sam9rl()	(0)
 #define cpu_is_at91cap9()	(0)
+#define cpu_is_at91sam9g10()	(0)
+#define cpu_is_at91sam9g45()	(0)
 
 #endif /* __ASM_ARCH_CPU_H */
-- 
1.5.3.7

