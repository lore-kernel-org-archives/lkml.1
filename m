Return-Path: <linux-kernel-owner+w=401wt.eu-S1763409AbXGJJdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763409AbXGJJdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763928AbXGJJ3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:29:13 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:39232 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764199AbXGJJ2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:28:53 -0400
Message-Id: <20070710093124.689069269@de.ibm.com>
References: <20070710092935.896013926@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 10 Jul 2007 11:29:51 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Stefan Weinhuber <wein@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 16/16] vmlogrdr function annotation.
Content-Disposition: inline; filename=016-vmlogrdr-initexit.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

Use __init and __exit for vmlogrdr. Both functions are only referenced
by the module_init exit macros, so this change should be fine.

Acked-by: Stefan Weinhuber <wein@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/vmlogrdr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: quilt-2.6/drivers/s390/char/vmlogrdr.c
===================================================================
--- quilt-2.6.orig/drivers/s390/char/vmlogrdr.c
+++ quilt-2.6/drivers/s390/char/vmlogrdr.c
@@ -835,7 +835,7 @@ static void vmlogrdr_cleanup(void)
 }
 
 
-static int vmlogrdr_init(void)
+static int __init vmlogrdr_init(void)
 {
 	int rc;
 	int i;
@@ -885,7 +885,7 @@ cleanup:
 }
 
 
-static void vmlogrdr_exit(void)
+static void __exit vmlogrdr_exit(void)
 {
 	vmlogrdr_cleanup();
 	printk (KERN_INFO "vmlogrdr: driver unloaded\n");

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

