Return-Path: <linux-kernel-owner+w=401wt.eu-S1764047AbXLMSpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764047AbXLMSpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 13:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760067AbXLMSpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 13:45:08 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33412 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759733AbXLMSpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 13:45:04 -0500
Date: Thu, 13 Dec 2007 19:45:07 +0100
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: default to PCI=y
Message-ID: <20071213184507.GC21616@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI is one of the few hardware stuff where defaulting to y makes sense.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
753cd05e76043bb56edb30b2277be9f3e77ee0c4 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 80b7ba4..2897cc0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1371,7 +1371,7 @@ menu "Bus options (PCI etc.)"
 config PCI
 	bool "PCI support" if !X86_VISWS
 	depends on !X86_VOYAGER
-	default y if X86_VISWS
+	default y
 	select ARCH_SUPPORTS_MSI if (X86_LOCAL_APIC && X86_IO_APIC)
 	help
 	  Find out whether you have a PCI motherboard. PCI is the name of a

