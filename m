Return-Path: <linux-kernel-owner+w=401wt.eu-S932076AbZBYPQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbZBYPQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760174AbZBYPJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:09:18 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:56296 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162AbZBYPIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:08:44 -0500
Message-Id: <20090225150838.464129126@de.ibm.com>
References: <20090225150622.529143164@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 25 Feb 2009 16:07:03 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch/s390 41/46] s390: remove duplicate nul-termination of string
Content-Disposition: inline; filename=140-parm-nul-term.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>

strlcpy() does already NUL-terminate the destination string.

Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/early.c |    1 -
 1 file changed, 1 deletion(-)

Index: quilt-2.6/arch/s390/kernel/early.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/early.c
+++ quilt-2.6/arch/s390/kernel/early.c
@@ -352,7 +352,6 @@ static void __init setup_boot_command_li
 
 	/* copy arch command line */
 	strlcpy(boot_command_line, COMMAND_LINE, ARCH_COMMAND_LINE_SIZE);
-	boot_command_line[ARCH_COMMAND_LINE_SIZE - 1] = 0;
 
 	/* append IPL PARM data to the boot command line */
 	if (MACHINE_IS_VM) {

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

