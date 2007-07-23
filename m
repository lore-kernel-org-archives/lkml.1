Return-Path: <linux-kernel-owner+w=401wt.eu-S932151AbXGWIzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151AbXGWIzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbXGWIyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:54:04 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:40233 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757579AbXGWIyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:54:02 -0400
Message-Id: <20070723085646.444431221@de.ibm.com>
References: <20070723084548.394178614@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 23 Jul 2007 10:45:51 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 3/9] cio: css_sch_device_register() can be made static.
Content-Disposition: inline; filename=003-cio-static.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/css.c |    2 +-
 drivers/s390/cio/css.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

Index: quilt-2.6/drivers/s390/cio/css.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/css.c
+++ quilt-2.6/drivers/s390/cio/css.c
@@ -109,7 +109,7 @@ css_subchannel_release(struct device *de
 	}
 }
 
-int css_sch_device_register(struct subchannel *sch)
+static int css_sch_device_register(struct subchannel *sch)
 {
 	int ret;
 
Index: quilt-2.6/drivers/s390/cio/css.h
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/css.h
+++ quilt-2.6/drivers/s390/cio/css.h
@@ -139,7 +139,6 @@ struct css_driver {
  */
 extern struct bus_type css_bus_type;
 
-extern int css_sch_device_register(struct subchannel *);
 extern void css_sch_device_unregister(struct subchannel *);
 extern struct subchannel * get_subchannel_by_schid(struct subchannel_id);
 extern int css_init_done;

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

