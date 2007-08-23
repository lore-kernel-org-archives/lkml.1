Return-Path: <linux-kernel-owner+w=401wt.eu-S932673AbXHWX1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbXHWX1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbXHWX05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:26:57 -0400
Received: from rex.snapgear.com ([203.143.235.140]:47120 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754129AbXHWX05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:26:57 -0400
Date: Fri, 24 Aug 2007 09:26:06 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200708232326.l7NNQ6da013532@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: include linux/fs.h for getname()
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/fs.h to get the prototype for getname().
Build fix.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naur ORG.linux-2.6.23-rc3/arch/m68knommu/kernel/process.c linux-2.6.23-rc3/arch/m68knommu/kernel/process.c
--- ORG.linux-2.6.23-rc3/arch/m68knommu/kernel/process.c	2007-08-14 15:30:46.000000000 +1000
+++ linux-2.6.23-rc3/arch/m68knommu/kernel/process.c	2007-08-14 16:17:36.000000000 +1000
@@ -28,6 +28,7 @@
 #include <linux/a.out.h>
 #include <linux/interrupt.h>
 #include <linux/reboot.h>
+#include <linux/fs.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
