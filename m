Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbXJ3Emo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbXJ3Emo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 00:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbXJ3EmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 00:42:22 -0400
Received: from rex.snapgear.com ([203.143.235.140]:37111 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752541AbXJ3EmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 00:42:21 -0400
Date: Tue, 30 Oct 2007 14:41:10 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710300441.l9U4fAxn032192@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: fix pread/pwrite defines
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix system call defines for system call 180 and 181 to match the
underlying system call table function entries. System call 180 calls
sys_pread64, and 181 calls sys_pwrite64, so make the definitions
match.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/include/asm-m68knommu/unistd.h linux-2.6.23-uc0/include/asm-m68knommu/unistd.h
--- linux-2.6.23/include/asm-m68knommu/unistd.h	2007-10-19 10:21:31.000000000 +1000
+++ linux-2.6.23-uc0/include/asm-m68knommu/unistd.h	2007-10-19 10:32:28.000000000 +1000
@@ -185,8 +185,8 @@
 #define __NR_rt_sigtimedwait	177
 #define __NR_rt_sigqueueinfo	178
 #define __NR_rt_sigsuspend	179
-#define __NR_pread		180
-#define __NR_pwrite		181
+#define __NR_pread64		180
+#define __NR_pwrite64		181
 #define __NR_lchown		182
 #define __NR_getcwd		183
 #define __NR_capget		184
