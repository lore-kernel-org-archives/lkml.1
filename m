Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbYKYVm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbYKYVm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:42:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYKYVge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:36:34 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:55788 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbYKYVgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:36:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=RxqqrS4H0BgM3yUNGmy+SR9RfqlahTYff+RqleSeKt+LpreedANkwgiQJjw+TBnmw6
         2RFVbeEaMiOSq3HP8kDyctzNn2QjxIP5PmSOR2CVLVpU97lFs4ExliBAgNBBIeA3tHvC
         7Oqi6/heRLhzW1rrCK8YuBwzVj8oV6ZP1pfNo=
To: linux-kernel@vger.kernel.org
Subject: [patch 17/24] perfmon: X86 64-bit system calls support (x86)
From: eranian@googlemail.com
Date: Tue, 25 Nov 2008 13:36:32 -0800 (PST)
Message-ID: <492c6fe0.25e2660a.15b8.319e@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchs adds the entry points for the X86 64-bit perfmon system calls.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o3/arch/x86/include/asm/unistd_64.h
===================================================================
--- o3.orig/arch/x86/include/asm/unistd_64.h	2008-11-03 11:17:02.000000000 +0100
+++ o3/arch/x86/include/asm/unistd_64.h	2008-11-03 11:17:59.000000000 +0100
@@ -653,7 +653,16 @@
 __SYSCALL(__NR_pipe2, sys_pipe2)
 #define __NR_inotify_init1			294
 __SYSCALL(__NR_inotify_init1, sys_inotify_init1)
-
+#define __NR_pfm_create				295
+__SYSCALL(__NR_pfm_create, sys_pfm_create)
+#define __NR_pfm_write				(__NR_pfm_create+1)
+__SYSCALL(__NR_pfm_write, sys_pfm_write)
+#define __NR_pfm_read				(__NR_pfm_create+2)
+ __SYSCALL(__NR_pfm_read, sys_pfm_read)
+#define __NR_pfm_attach				(__NR_pfm_create+3)
+__SYSCALL(__NR_pfm_attach, sys_pfm_attach)
+#define __NR_pfm_set_state			(__NR_pfm_create+4)
+__SYSCALL(__NR_pfm_set_state, sys_pfm_set_state)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR

-- 

