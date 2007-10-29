Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbXJ2Mur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbXJ2Mur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 08:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbXJ2Mtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 08:49:49 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41595 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756734AbXJ2Mts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 08:49:48 -0400
Date: Mon, 29 Oct 2007 13:49:57 +0100
From: Adrian Bunk <bunk@kernel.org>
To: gerg@uclinux.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] m68knommu: remove duplicate exports
Message-ID: <20071029124957.GN7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One EXPORT_SYMBOL should be enough for everyone.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/m68knommu/kernel/m68k_ksyms.c |   11 -----------
 1 file changed, 11 deletions(-)

db7c0d48feac0857d0bc2e79147b63d5f9675077 
diff --git a/arch/m68knommu/kernel/m68k_ksyms.c b/arch/m68knommu/kernel/m68k_ksyms.c
index f795062..53fad14 100644
--- a/arch/m68knommu/kernel/m68k_ksyms.c
+++ b/arch/m68knommu/kernel/m68k_ksyms.c
@@ -24,14 +24,6 @@ extern int dump_fpu(struct pt_regs *, elf_fpregset_t *);
 EXPORT_SYMBOL(__ioremap);
 EXPORT_SYMBOL(iounmap);
 EXPORT_SYMBOL(dump_fpu);
-EXPORT_SYMBOL(strnlen);
-EXPORT_SYMBOL(strrchr);
-EXPORT_SYMBOL(strstr);
-EXPORT_SYMBOL(strchr);
-EXPORT_SYMBOL(strcat);
-EXPORT_SYMBOL(strlen);
-EXPORT_SYMBOL(strcmp);
-EXPORT_SYMBOL(strncmp);
 
 EXPORT_SYMBOL(ip_fast_csum);
 
@@ -46,9 +38,6 @@ EXPORT_SYMBOL(csum_partial_copy_nocheck);
    it's OK to leave it out of version control.  */
 EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(memset);
-EXPORT_SYMBOL(memcmp);
-EXPORT_SYMBOL(memscan);
-EXPORT_SYMBOL(memmove);
 
 EXPORT_SYMBOL(__down_failed);
 EXPORT_SYMBOL(__down_failed_interruptible);

