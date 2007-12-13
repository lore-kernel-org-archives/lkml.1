Return-Path: <linux-kernel-owner+w=401wt.eu-S1760008AbXLMSqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008AbXLMSqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 13:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764019AbXLMSpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 13:45:23 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33418 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764003AbXLMSpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 13:45:21 -0500
Date: Thu, 13 Dec 2007 19:45:24 +0100
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Ungerer <gerg@uclinux.org>
Subject: [2.6 patch] m68knommu: remove duplicate exports
Message-ID: <20071213184524.GE21616@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One EXPORT_SYMBOL should be enough for everyone.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Greg Ungerer <gerg@uclinux.org>

---

This patch has been sent on:
- 29 Oct 2007

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

