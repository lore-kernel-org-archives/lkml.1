Return-Path: <linux-kernel-owner+w=401wt.eu-S938958AbXHNGtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938958AbXHNGtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 02:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761558AbXHNGsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 02:48:20 -0400
Received: from rex.snapgear.com ([203.143.235.140]:45191 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758736AbXHNGsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 02:48:19 -0400
Date: Tue, 14 Aug 2007 16:46:52 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200708140646.l7E6kqOJ014612@goober>
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
