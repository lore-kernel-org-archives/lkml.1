Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbXHNV0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbXHNV0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580AbXHNVW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:22:29 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38403 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752511AbXHNVW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:22:27 -0400
Date: Tue, 14 Aug 2007 23:22:14 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] i386: unexport machine_id
Message-ID: <20070814212214.GX18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused EXPORT_SYMBOL(machine_id).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- a/arch/i386/kernel/setup.c
+++ b/arch/i386/kernel/setup.c
@@ -86,9 +86,6 @@ unsigned long mmu_cr4_features;
 
 /* for MCA, but anyone else can use it if they want */
 unsigned int machine_id;
-#ifdef CONFIG_MCA
-EXPORT_SYMBOL(machine_id);
-#endif
 unsigned int machine_submodel_id;
 unsigned int BIOS_revision;
 unsigned int mca_pentium_flag;

