Return-Path: <linux-kernel-owner+w=401wt.eu-S966428AbXJSDyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966428AbXJSDyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 23:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965840AbXJSDym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 23:54:42 -0400
Received: from rex.snapgear.com ([203.143.235.140]:43524 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964813AbXJSDyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 23:54:41 -0400
Date: Fri, 19 Oct 2007 13:54:00 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710190354.l9J3s0pd004641@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: local module/elf definitions
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Up to now m68knommu has been using the asm-m68k/module.h instead of
defining its own. There are recent changes there that we don't need
(fixups specifically). We don't need much support here so it makes
sense to have an m68knommu specific one now.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/include/asm-m68knommu/module.h linux-2.6.23-uc0/include/asm-m68knommu/module.h
--- linux-2.6.23/include/asm-m68knommu/module.h	2007-10-19 10:21:30.000000000 +1000
+++ linux-2.6.23-uc0/include/asm-m68knommu/module.h	2007-10-19 10:32:26.000000000 +1000
@@ -1 +1,11 @@
-#include <asm-m68k/module.h>
+#ifndef ASM_M68KNOMMU_MODULE_H
+#define ASM_M68KNOMMU_MODULE_H
+
+struct mod_arch_specific {
+};
+
+#define Elf_Shdr Elf32_Shdr
+#define Elf_Sym Elf32_Sym
+#define Elf_Ehdr Elf32_Ehdr
+
+#endif /* ASM_M68KNOMMU_MODULE_H */
