Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbXJ2MuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbXJ2MuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 08:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbXJ2Mt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 08:49:28 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41590 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755854AbXJ2Mt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 08:49:27 -0400
Date: Mon, 29 Oct 2007 13:49:36 +0100
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: merge EARLY_PRINTK options
Message-ID: <20071029124936.GL7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch merges the x86_64 EARLY_PRINTK option into the i386 one.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/Kconfig.debug  |    3 +--
 arch/x86/Kconfig.x86_64 |    4 ----
 2 files changed, 1 insertion(+), 6 deletions(-)

9ac736d36f60cbfe4343f51b0f776e2068ceebe4 
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index a2fa37d..3de185a 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -6,9 +6,8 @@ config TRACE_IRQFLAGS_SUPPORT
 source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
-	bool "Early printk" if EMBEDDED && DEBUG_KERNEL
+	bool "Early printk" if EMBEDDED && DEBUG_KERNEL && X86_32
 	default y
-	depends on X86_32
 	help
 	  Write kernel log output directly into the VGA buffer or to a serial
 	  port.
diff --git a/arch/x86/Kconfig.x86_64 b/arch/x86/Kconfig.x86_64
index e2542e5..04b8095 100644
--- a/arch/x86/Kconfig.x86_64
+++ b/arch/x86/Kconfig.x86_64
@@ -97,10 +97,6 @@ config X86_CMPXCHG
 	bool
 	default y
 
-config EARLY_PRINTK
-	bool
-	default y
-
 config GENERIC_ISA_DMA
 	bool
 	default y

