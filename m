Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbZBEWrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbZBEWrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZBEWrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:47:11 -0500
Received: from everest.las.ic.unicamp.br ([143.106.60.118]:56331 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752863AbZBEWrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:47:10 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Feb 2009 17:47:10 EST
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: glommer@redhat.com, mingo@elte.hu
Subject: [PATCH 1/6] x86: rename __FIXADDR_SIZE and __FIXADDR_BOOT_SIZE
Date: Thu,  5 Feb 2009 20:39:41 -0200
Message-Id: <1233873586-7149-2-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1233873586-7149-1-git-send-email-gustavo@las.ic.unicamp.br>
References: <1233873586-7149-1-git-send-email-gustavo@las.ic.unicamp.br>
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
index c7115c1..a50e0e2 100644
--- a/arch/x86/include/asm/fixmap_32.h
+++ b/arch/x86/include/asm/fixmap_32.h
@@ -110,10 +110,10 @@ extern void reserve_top_address(unsigned long reserve);
 
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
1.5.6.4

