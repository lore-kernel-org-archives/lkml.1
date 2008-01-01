Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbYAANr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbYAANr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 08:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbYAANrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 08:47:04 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:37013 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040AbYAANrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 08:47:03 -0500
Date: Tue, 1 Jan 2008 15:46:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: default to PCI=y
Message-ID: <20080101134648.GF2360@does.not.exist>
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

This patch has been sent on:
- 13 Dec 2007

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

