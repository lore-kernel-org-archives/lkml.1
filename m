Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbZBEWwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbZBEWwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbZBEWwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:52:13 -0500
Received: from everest.las.ic.unicamp.br ([143.106.60.118]:52321 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751983AbZBEWwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:52:12 -0500
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: glommer@redhat.com, mingo@elte.hu
Subject: [PATCH 5/6] x86: Add CONFIG_EFI
Date: Thu,  5 Feb 2009 20:39:45 -0200
Message-Id: <1233873586-7149-6-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1233873586-7149-5-git-send-email-gustavo@las.ic.unicamp.br>
References: <1233873586-7149-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1233873586-7149-2-git-send-email-gustavo@las.ic.unicamp.br>
 <1233873586-7149-3-git-send-email-gustavo@las.ic.unicamp.br>
 <1233873586-7149-4-git-send-email-gustavo@las.ic.unicamp.br>
 <1233873586-7149-5-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FIX_EFI_IO_MAP_FIRST_PAGE is used only when EFI is enabled.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
Acked-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/include/asm/fixmap_64.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/fixmap_64.h b/arch/x86/include/asm/fixmap_64.h
index 8a328fc..5dc7941 100644
--- a/arch/x86/include/asm/fixmap_64.h
+++ b/arch/x86/include/asm/fixmap_64.h
@@ -47,9 +47,11 @@ enum fixed_addresses {
 	FIX_IO_APIC_BASE_0,
 	FIX_IO_APIC_BASE_END = FIX_IO_APIC_BASE_0 + MAX_IO_APICS - 1,
 #endif
+#ifdef CONFIG_EFI
 	FIX_EFI_IO_MAP_LAST_PAGE,
 	FIX_EFI_IO_MAP_FIRST_PAGE = FIX_EFI_IO_MAP_LAST_PAGE
 				  + MAX_EFI_IO_PAGES - 1,
+#endif
 #ifdef CONFIG_PARAVIRT
 	FIX_PARAVIRT_BOOTMAP,
 #endif
-- 
1.5.6.4

