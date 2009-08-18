Return-Path: <linux-kernel-owner+w=401wt.eu-S1758309AbZHRJzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309AbZHRJzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 05:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758064AbZHRJzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 05:55:36 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:57797 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051AbZHRJzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 05:55:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Do7N7y5PFyonkUl3YinPoH7FpFIqqIsN/sur51Ydet81oF45UXnSiEZAn8tUo5H/gD
         +uNzlyjTTSELVucrQRlZdQASWz6dC/dRxNHLso9SAkPXjakksZcfh7sp4BzfoCE5hr/f
         lWu3/4xQvPD0X5Rr7HCKQle9sovU9HQMGOGdQ=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 2/2] Staging: sep: fix warnings
Date: Tue, 18 Aug 2009 13:48:52 +0400
Message-Id: <1250588932-7595-2-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.4
In-Reply-To: <1250588932-7595-1-git-send-email-a.beregalov@gmail.com>
References: <1250588932-7595-1-git-send-email-a.beregalov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this warnings
drivers/staging/sep/sep_driver.c:290: warning: format '%d' expects type 'int', but argument 2 has type 'long unsigned int'
drivers/staging/sep/sep_driver.c:382: warning: unused variable 'sep'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/sep/sep_driver.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 531814b..e131c9d 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -287,7 +287,7 @@ static int sep_map_and_alloc_shared_area(struct sep_device *sep,
 	sep->shared_area = sep->shared_addr;
 	/* set the physical address of the shared area */
 	sep->shared_area_bus = sep->shared_bus;
-	edbg("sep: shared_area %d bytes @%p (bus %08llx)\n",
+	edbg("sep: shared_area %lu bytes @%p (bus %08llx)\n",
 		size, sep->shared_addr, (unsigned long long)sep->shared_bus);
 	return 0;
 }
@@ -379,7 +379,7 @@ end_function:
 -------------------------------------------------------------*/
 static int sep_release(struct inode *inode_ptr, struct file *filp)
 {
-	struct sep_driver *sep =  filp->private_data;
+/*	struct sep_driver *sep =  filp->private_data; */
 	dbg("----------->SEP Driver: sep_release start\n");
 
 #if 0				/*!SEP_DRIVER_POLLING_MODE */
-- 
1.6.4

