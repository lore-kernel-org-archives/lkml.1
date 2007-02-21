Return-Path: <linux-kernel-owner+w=401wt.eu-S1161224AbXBUKED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161224AbXBUKED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 05:04:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161206AbXBUKD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 05:03:56 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:1047 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161192AbXBUKDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 05:03:51 -0500
Date: Wed, 21 Feb 2007 11:03:51 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: holzheu@de.ibm.com
Subject: [S390] Replace $(ARCH) macros in Makefile
Message-ID: <20070221100351.GL13419@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@de.ibm.com>

[S390] Replace $(ARCH) macros in Makefile

Since $(ARCH) is always "s390" we can replace it with "s390".

Signed-off-by: Michael Holzheu <holzheu@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/Makefile |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -urpN linux-2.6/arch/s390/Makefile linux-2.6-patched/arch/s390/Makefile
--- linux-2.6/arch/s390/Makefile	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6-patched/arch/s390/Makefile	2007-02-21 10:47:36.000000000 +0100
@@ -82,18 +82,18 @@ AFLAGS		+= $(aflags-y)
 OBJCOPYFLAGS	:= -O binary
 LDFLAGS_vmlinux := -e start
 
-head-y		:= arch/$(ARCH)/kernel/head.o arch/$(ARCH)/kernel/init_task.o
+head-y		:= arch/s390/kernel/head.o arch/s390/kernel/init_task.o
 
-core-y		+= arch/$(ARCH)/mm/ arch/$(ARCH)/kernel/ arch/$(ARCH)/crypto/ \
-		   arch/$(ARCH)/appldata/ arch/$(ARCH)/hypfs/
-libs-y		+= arch/$(ARCH)/lib/
+core-y		+= arch/s390/mm/ arch/s390/kernel/ arch/s390/crypto/ \
+		   arch/s390/appldata/ arch/s390/hypfs/
+libs-y		+= arch/s390/lib/
 drivers-y	+= drivers/s390/
-drivers-$(CONFIG_MATHEMU) += arch/$(ARCH)/math-emu/
+drivers-$(CONFIG_MATHEMU) += arch/s390/math-emu/
 
 # must be linked after kernel
 drivers-$(CONFIG_OPROFILE)	+= arch/s390/oprofile/
 
-boot		:= arch/$(ARCH)/boot
+boot		:= arch/s390/boot
 
 all: image
 
-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher 
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294
   
"Reality continues to ruin my life." - Calvin.

