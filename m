Return-Path: <linux-kernel-owner+w=401wt.eu-S1765818AbXGWIze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765818AbXGWIze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761755AbXGWIyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:54:07 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:59294 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012AbXGWIyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:54:05 -0400
Message-Id: <20070723085652.753447559@de.ibm.com>
References: <20070723084548.394178614@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 23 Jul 2007 10:45:52 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 4/9] cio: Remove remains of _ccw_device_get_device_number().
Content-Disposition: inline; filename=004-cio-devno.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/device_ops.c |    7 -------
 1 file changed, 7 deletions(-)

Index: quilt-2.6/drivers/s390/cio/device_ops.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/device_ops.c
+++ quilt-2.6/drivers/s390/cio/device_ops.c
@@ -635,12 +635,6 @@ _ccw_device_get_subchannel_number(struct
 	return cdev->private->schid.sch_no;
 }
 
-int
-_ccw_device_get_device_number(struct ccw_device *cdev)
-{
-	return cdev->private->dev_id.devno;
-}
-
 
 MODULE_LICENSE("GPL");
 EXPORT_SYMBOL(ccw_device_set_options_mask);
@@ -658,6 +652,5 @@ EXPORT_SYMBOL(ccw_device_get_path_mask);
 EXPORT_SYMBOL(read_conf_data);
 EXPORT_SYMBOL(read_dev_chars);
 EXPORT_SYMBOL(_ccw_device_get_subchannel_number);
-EXPORT_SYMBOL(_ccw_device_get_device_number);
 EXPORT_SYMBOL_GPL(ccw_device_get_chp_desc);
 EXPORT_SYMBOL_GPL(read_conf_data_lpm);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

