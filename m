Return-Path: <linux-kernel-owner+w=401wt.eu-S933173AbXH0VdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173AbXH0VdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764795AbXH0V2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:28:13 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58818 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764470AbXH0V2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:28:09 -0400
Date: Mon, 27 Aug 2007 23:28:08 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] i386: unexport machine_id
Message-ID: <20070827212808.GT4121@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused EXPORT_SYMBOL(machine_id).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 14 Aug 2007

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

