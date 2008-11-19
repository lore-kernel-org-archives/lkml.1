Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbYKSNQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbYKSNQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 08:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYKSNQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 08:16:25 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:52375 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbYKSNQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 08:16:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:bcc:subject:date:user-agent:message-id;
        b=AxyRDwAhyCGxJ0Dg502FN8Ft8jfa8lA9+wEo9HEZLHaD7xUtlCVL4LszPU/4fDpfte
         6onxd57t7ok9FnQSUMDcbrURfb1S+Jtqw/ThY876SMJrwJLT471wifNcvJ4e52YFNkmN
         nfApgt435ZmDvBRXRUUN9HWS7czBNFpet+poA=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Mike Rapoport <mike@compulab.co.il>,
       Mike Lavender <mike@steroidmicros.com>,
       David Hinds <dahinds@users.sourceforge.net>
Subject: [PATCH 1/4] drivers/mtd/nand/cafe_nand.c: mark {__init|__exit} for
 {init|exit} functions 
Date: Wed, 19 Nov 2008 21:16:16 +0800
User-Agent: sniper-patch-carrier/1.06
Message-ID: <492411a6.08486e0a.4d9d.ffffe118@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
index b8064bf..7d7a80b 100644
--- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -899,12 +899,12 @@ static struct pci_driver cafe_nand_pci_driver = {
 	.resume = cafe_nand_resume,
 };
 
-static int cafe_nand_init(void)
+static int __init cafe_nand_init(void)
 {
 	return pci_register_driver(&cafe_nand_pci_driver);
 }
 
-static void cafe_nand_exit(void)
+static void __exit cafe_nand_exit(void)
 {
 	pci_unregister_driver(&cafe_nand_pci_driver);
 }

