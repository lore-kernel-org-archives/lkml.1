Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbYJQPLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbYJQPLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbYJQPFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:05:55 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:22167 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbYJQPFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:05:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=i3AicxfvSzcKuerCoOP9TaRgcFmf8UOTVvHiUSAbPlatZjRIvyAp70+24/bFKzzfIY
         UHNBfw/mZ3u5/OuKhQb32BVlnGsYbaHAZ0U3umpLvYb1TPBmPQ4UapnPOo8E2lyhmg6P
         egMVdibP5YX2Erb/We4Agpq2NPggi27pbjHsU=
To: linux-kernel@vger.kernel.org
Subject: [patch 17/24] perfmon3:  X86 64-bit system calls support
From: eranian@googlemail.com
Date: Fri, 17 Oct 2008 08:05:51 -0700 (PDT)
Message-ID: <48f8a9cf.0405560a.160c.6519@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchs adds the entry points for the X86 64-bit perfmon system calls.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o3/include/asm-x86/unistd_64.h
===================================================================
--- o3.orig/include/asm-x86/unistd_64.h	2008-10-10 11:57:02.000000000 +0200
+++ o3/include/asm-x86/unistd_64.h	2008-10-10 12:06:15.000000000 +0200
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

