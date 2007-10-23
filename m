Return-Path: <linux-kernel-owner+w=401wt.eu-S1752104AbXJWEjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbXJWEjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 00:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbXJWEiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 00:38:55 -0400
Received: from rex.snapgear.com ([203.143.235.140]:58872 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751538AbXJWEix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 00:38:53 -0400
Date: Tue, 23 Oct 2007 14:37:54 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710230437.l9N4bsMT001784@goober>
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
