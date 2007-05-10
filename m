Return-Path: <linux-kernel-owner+w=401wt.eu-S1762287AbXEJN57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762287AbXEJN57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbXEJN42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:56:28 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:52394 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759124AbXEJN4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:56:20 -0400
Message-Id: <20070510135643.836311002@de.ibm.com>
References: <20070510135152.178104939@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 May 2007 15:51:57 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 05/15] dasd: Fix modular build.
Content-Disposition: inline; filename=005-dasd-modular.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Add missing export of dasd_generic_read_dev_chars().

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/block/dasd.c |    1 +
 1 file changed, 1 insertion(+)

Index: quilt-2.6/drivers/s390/block/dasd.c
===================================================================
--- quilt-2.6.orig/drivers/s390/block/dasd.c
+++ quilt-2.6/drivers/s390/block/dasd.c
@@ -2219,6 +2219,7 @@ int dasd_generic_read_dev_chars(struct d
 	dasd_sfree_request(cqr, cqr->device);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(dasd_generic_read_dev_chars);
 
 static int __init
 dasd_init(void)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

