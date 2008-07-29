Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbYG2Ft5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbYG2Ft5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 01:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbYG2Fs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 01:48:58 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:55506 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbYG2Fs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 01:48:57 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 3/6] x86: coding style fixes to arch/x86/kernel/crash_dump_64.c
Date: Tue, 29 Jul 2008 02:48:53 -0300
Message-Id: <1217310536-7181-4-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217310536-7181-3-git-send-email-gustavo@las.ic.unicamp.br>
References: <gustavo@las.ic.unicamp.br>
 <1217310536-7181-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1217310536-7181-2-git-send-email-gustavo@las.ic.unicamp.br>
 <1217310536-7181-3-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix conding style without change crash_dump_64.o

 arch/x86/kernel/crash_dump_64.o
 text    data     bss     dec     hex filename
 129       0       0     129      81 crash_dump_64.o.after
 129       0       0     129      81 crash_dump_64.o.before

md5:
885b52c1b92737e6b12e5107e90fc1f1  crash_dump_64.o.after
885b52c1b92737e6b12e5107e90fc1f1  crash_dump_64.o.before

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/crash_dump_64.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/crash_dump_64.c b/arch/x86/kernel/crash_dump_64.c
index 15e6c6b..d3e524c 100644
--- a/arch/x86/kernel/crash_dump_64.c
+++ b/arch/x86/kernel/crash_dump_64.c
@@ -7,9 +7,8 @@
 
 #include <linux/errno.h>
 #include <linux/crash_dump.h>
-
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 /**
  * copy_oldmem_page - copy one page from "oldmem"
@@ -25,7 +24,7 @@
  * in the current kernel. We stitch up a pte, similar to kmap_atomic.
  */
 ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
-                               size_t csize, unsigned long offset, int userbuf)
+		size_t csize, unsigned long offset, int userbuf)
 {
 	void  *vaddr;
 
-- 
1.5.4.5

