Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbYGUAEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbYGUAEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757014AbYGUADR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:03:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:56730 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbYGUADP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:03:15 -0400
Subject: [PATCH 6/22] cris: Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, starvik@axis.com,
       jesper.nilsson@axis.com, dev-etrax@axis.com
In-Reply-To: <1216596106.3679.98.camel@jaswinder.satnam>
References: <1216592500.3679.14.camel@jaswinder.satnam>
	 <1216592798.3679.22.camel@jaswinder.satnam>
	 <1216592879.3679.24.camel@jaswinder.satnam>
	 <1216593035.3679.27.camel@jaswinder.satnam>
	 <1216596035.3679.95.camel@jaswinder.satnam>
	 <1216596106.3679.98.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 04:55:25 +0530
Message-Id: <1216596325.3679.104.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring arch-dependent syscalls for cris architecture

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 include/asm-cris/syscalls.h |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/asm-cris/syscalls.h b/include/asm-cris/syscalls.h
index e69de29..711adad 100644
--- a/include/asm-cris/syscalls.h
+++ b/include/asm-cris/syscalls.h
@@ -0,0 +1,21 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_CRIS_SYSCALLS_H
+#define _ASM_CRIS_SYSCALLS_H
+
+/* kernel/sys_cris.c */
+asmlinkage unsigned long old_mmap(unsigned long __user *);
+asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, unsigned long);
+asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
+
+#endif /* _ASM_CRIS_SYSCALLS_H */
-- 
1.5.5.1



