Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbYKZIsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbYKZIsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbYKZImp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:42:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:43331 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbYKZImo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:42:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:from:date:message-id;
        b=xy53xAgSjxSqmdUUV9lI/6JHqiEWFUsYAzQlTcjzukSLB/HPP3OebVpzjqUO9Zi6f6
         B3s5Z/p79gY6SO+BNjYDnBI5wNzpsGHh86GEvE8ARoGcu/v0tDBr/t4VT1Ol4vXV500/
         +LzSe+FSE/MTXAziCV6d7sFC3EgEwK4ES1afk=
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       andi@firstfloor.org, eranian@gmail.com, sfr@canb.auug.org.au
Subject: [patch 17/24] perfmon: X86 64-bit system calls support (x86)
From: eranian@googlemail.com
Date: Wed, 26 Nov 2008 00:42:42 -0800 (PST)
Message-ID: <492d0c02.02a1660a.15f1.ffffdbb5@mx.google.com>
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

