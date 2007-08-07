Return-Path: <linux-kernel-owner+w=401wt.eu-S1763788AbXHGLRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763788AbXHGLRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 07:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761987AbXHGLPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 07:15:19 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:47409 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759185AbXHGLPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 07:15:09 -0400
Message-Id: <20070807111845.647123600@de.ibm.com>
References: <20070807111519.972871123@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 07 Aug 2007 13:15:24 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 04/18] remove DEFAULT_MIGRATION_COST
Content-Disposition: inline; filename=004-migration.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

0437e109e1841607f2988891eaa36c531c6aa6ac removes the migration
cost init code. Remove the s390 leftovers as well.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/Kconfig |    4 ----
 1 file changed, 4 deletions(-)

Index: quilt-2.6/arch/s390/Kconfig
===================================================================
--- quilt-2.6.orig/arch/s390/Kconfig
+++ quilt-2.6/arch/s390/Kconfig
@@ -109,10 +109,6 @@ config HOTPLUG_CPU
 	  can be controlled through /sys/devices/system/cpu/cpu#.
 	  Say N if you want to disable CPU hotplug.
 
-config DEFAULT_MIGRATION_COST
-	int
-	default "1000000"
-
 config MATHEMU
 	bool "IEEE FPU emulation"
 	depends on MARCH_G5

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

