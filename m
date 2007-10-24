Return-Path: <linux-kernel-owner+w=401wt.eu-S1762857AbXJXQhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762857AbXJXQhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759671AbXJXQYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:24:38 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60931 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759643AbXJXQYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:24:36 -0400
Date: Wed, 24 Oct 2007 18:25:06 +0200
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86/kernel/setup_32.c: unexport machine_id
Message-ID: <20071024162506.GU30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused EXPORT_SYMBOL(machine_id).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
2cb43d8ae339c609318adf16a835e990fd79ee21 
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index ba2e165..e8ddc4c 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -84,9 +84,6 @@ unsigned long mmu_cr4_features;
 
 /* for MCA, but anyone else can use it if they want */
 unsigned int machine_id;
-#ifdef CONFIG_MCA
-EXPORT_SYMBOL(machine_id);
-#endif
 unsigned int machine_submodel_id;
 unsigned int BIOS_revision;
 unsigned int mca_pentium_flag;

