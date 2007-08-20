Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbXHTA1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbXHTA1B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 20:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbXHTA0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 20:26:42 -0400
Received: from rex.snapgear.com ([203.143.235.140]:59730 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755270AbXHTA0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 20:26:41 -0400
Date: Mon, 20 Aug 2007 10:25:26 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200708200025.l7K0PQKH009376@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: include linux/fs.h for do_pip()
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/fs.h to get the prototype for do_pipe().

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naur ORG.linux-2.6.23-rc3/arch/m68knommu/kernel/sys_m68k.c linux-2.6.23-rc3/arch/m68knommu/kernel/sys_m68k.c
--- ORG.linux-2.6.23-rc3/arch/m68knommu/kernel/sys_m68k.c	2007-07-09 09:32:17.000000000 +1000
+++ linux-2.6.23-rc3/arch/m68knommu/kernel/sys_m68k.c	2007-08-14 16:17:27.000000000 +1000
@@ -18,6 +18,7 @@
 #include <linux/mman.h>
 #include <linux/file.h>
 #include <linux/utsname.h>
+#include <linux/fs.h>
 
 #include <asm/setup.h>
 #include <asm/uaccess.h>
