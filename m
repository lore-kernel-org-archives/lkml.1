Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbXJ2Mto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbXJ2Mto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 08:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbXJ2MtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 08:49:08 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33031 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752904AbXJ2MtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 08:49:07 -0400
Date: Mon, 29 Oct 2007 13:49:16 +0100
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove the dead X86_REMOTE_DEBUG option
Message-ID: <20071029124916.GK7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the dead X86_REMOTE_DEBUG option.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
6ea2f2bbd1646369a3affbed8ad1af5acc1530cd 
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 970b2de..a2fa37d 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -113,7 +113,4 @@ config IOMMU_LEAK
 	  Add a simple leak tracer to the IOMMU code. This is useful when you
 	  are debugging a buggy device driver that leaks IOMMU mappings.
 
-#config X86_REMOTE_DEBUG
-#	bool "kgdb debugging stub"
-
 endmenu

