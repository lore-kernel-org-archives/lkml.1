Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbXCEBsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbXCEBsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbXCEBry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:47:54 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49911 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751832AbXCEBrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:47:40 -0500
Date: Mon, 5 Mar 2007 02:47:42 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Zachary Amsden <zach@vmware.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make arch/i386/kernel/vmi.c:vmi_pmd_clear() static
Message-ID: <20070305014742.GR3441@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global vmi_pmd_clear() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc2-mm1/arch/i386/kernel/vmi.c.old	2007-03-04 20:32:08.000000000 +0100
+++ linux-2.6.21-rc2-mm1/arch/i386/kernel/vmi.c	2007-03-04 20:33:51.000000000 +0100
@@ -517,7 +517,7 @@
 	vmi_ops.set_pte(pte, ptep, vmi_flags_addr(mm, addr, VMI_PAGE_PT, 0));
 }
 
-void vmi_pmd_clear(pmd_t *pmd)
+static void vmi_pmd_clear(pmd_t *pmd)
 {
 	const pte_t pte = { 0 };
 	vmi_check_page_type(__pa(pmd) >> PAGE_SHIFT, VMI_PAGE_PMD);

