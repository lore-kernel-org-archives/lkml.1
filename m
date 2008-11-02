Return-Path: <linux-kernel-owner+w=401wt.eu-S1753868AbYKBCYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbYKBCYJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 22:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYKBCXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 22:23:42 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:34651 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbYKBCXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 22:23:41 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: glommer@redhat.com, mingo@elte.hu
Subject: [PATCH 1/6] x86: rename __FIXADDR_SIZE and __FIXADDR_BOOT_SIZE
Date: Sun,  2 Nov 2008 00:23:48 -0200
Message-Id: <1225592633-9948-2-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1225592633-9948-1-git-send-email-gustavo@las.ic.unicamp.br>
References: <1225592633-9948-1-git-send-email-gustavo@las.ic.unicamp.br>
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
index 09f29ab..5d533f0 100644
--- a/arch/x86/include/asm/fixmap_32.h
+++ b/arch/x86/include/asm/fixmap_32.h
@@ -114,10 +114,10 @@ extern void reserve_top_address(unsigned long reserve);
 
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

