Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbZBPAum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbZBPAum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbZBPAuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:50:19 -0500
Received: from everest.las.ic.unicamp.br ([143.106.60.118]:41729 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbZBPAuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:50:18 -0500
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: mingo@elte.hu
Cc: glommer@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] x86: rename __FIXADDR_SIZE and __FIXADDR_BOOT_SIZE
Date: Sun, 15 Feb 2009 21:48:52 -0300
Message-Id: <1234745339-18587-2-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1234745339-18587-1-git-send-email-gustavo@las.ic.unicamp.br>
References: <1234745339-18587-1-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename __FIXADDR_SIZE to FIXADDR_SIZE
and __FIXADDR_BOOT_SIZE to FIXADDR_BOOT_SIZE.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
Acked-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/include/asm/fixmap_32.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/fixmap_32.h b/arch/x86/include/asm/fixmap_32.h
index 047d9ba..d3fd0b9 100644
--- a/arch/x86/include/asm/fixmap_32.h
+++ b/arch/x86/include/asm/fixmap_32.h
@@ -106,10 +106,10 @@ extern void reserve_top_address(unsigned long reserve);
 
 #define FIXADDR_TOP	((unsigned long)__FIXADDR_TOP)
 
-#define __FIXADDR_SIZE	(__end_of_permanent_fixed_addresses << PAGE_SHIFT)
-#define __FIXADDR_BOOT_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
-#define FIXADDR_START		(FIXADDR_TOP - __FIXADDR_SIZE)
-#define FIXADDR_BOOT_START	(FIXADDR_TOP - __FIXADDR_BOOT_SIZE)
+#define FIXADDR_SIZE	(__end_of_permanent_fixed_addresses << PAGE_SHIFT)
+#define FIXADDR_BOOT_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
+#define FIXADDR_START		(FIXADDR_TOP - FIXADDR_SIZE)
+#define FIXADDR_BOOT_START	(FIXADDR_TOP - FIXADDR_BOOT_SIZE)
 
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASM_X86_FIXMAP_32_H */
-- 
1.6.0.6

