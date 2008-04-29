Return-Path: <linux-kernel-owner+w=401wt.eu-S1763317AbYD2OS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763317AbYD2OS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756491AbYD2OQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:16:03 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:59628 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbYD2OPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:15:55 -0400
Message-Id: <20080429140249.987171832@de.ibm.com>
References: <20080429140117.631962807@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Apr 2008 16:01:23 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Sam Ravnborg <sam@ravnborg.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 06/15] remove -traditional
Content-Disposition: inline; filename=006-traditional.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/Makefile   |    2 --
 arch/s390/lib/Makefile      |    2 --
 arch/s390/math-emu/Makefile |    1 -
 3 files changed, 5 deletions(-)

Index: quilt-2.6/arch/s390/kernel/Makefile
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/Makefile
+++ quilt-2.6/arch/s390/kernel/Makefile
@@ -2,8 +2,6 @@
 # Makefile for the linux kernel.
 #
 
-EXTRA_AFLAGS	:= -traditional
-
 #
 # Passing null pointers is ok for smp code, since we access the lowcore here.
 #
Index: quilt-2.6/arch/s390/lib/Makefile
===================================================================
--- quilt-2.6.orig/arch/s390/lib/Makefile
+++ quilt-2.6/arch/s390/lib/Makefile
@@ -2,8 +2,6 @@
 # Makefile for s390-specific library files..
 #
 
-EXTRA_AFLAGS := -traditional
-
 lib-y += delay.o string.o uaccess_std.o uaccess_pt.o
 obj-$(CONFIG_32BIT) += div64.o qrnnd.o
 lib-$(CONFIG_64BIT) += uaccess_mvcos.o
Index: quilt-2.6/arch/s390/math-emu/Makefile
===================================================================
--- quilt-2.6.orig/arch/s390/math-emu/Makefile
+++ quilt-2.6/arch/s390/math-emu/Makefile
@@ -5,4 +5,3 @@
 obj-$(CONFIG_MATHEMU) := math.o
 
 EXTRA_CFLAGS := -I$(src) -Iinclude/math-emu -w
-EXTRA_AFLAGS := -traditional

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

