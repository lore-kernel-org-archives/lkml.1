Return-Path: <linux-kernel-owner+w=401wt.eu-S933316AbXHWX21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933316AbXHWX21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933000AbXHWX13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:27:29 -0400
Received: from rex.snapgear.com ([203.143.235.140]:47122 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932580AbXHWX10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:27:26 -0400
Date: Fri, 24 Aug 2007 09:26:12 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200708232326.l7NNQC9i013537@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: include linux/fs.h for do_pip()
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/fs.h to get the prototype for do_pipe().
Build fix.

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
