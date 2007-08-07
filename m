Return-Path: <linux-kernel-owner+w=401wt.eu-S1762517AbXHGLUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762517AbXHGLUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 07:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762771AbXHGLPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 07:15:41 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:47411 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759446AbXHGLPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 07:15:11 -0400
Message-Id: <20070807111847.540161077@de.ibm.com>
References: <20070807111519.972871123@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 07 Aug 2007 13:15:32 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 12/18] cio: remove subchannel_add_files()
Content-Disposition: inline; filename=101-cio-remove.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

subchannel_add_files() no longer exists, remove from header.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/css.h |    1 -
 1 file changed, 1 deletion(-)

Index: quilt-2.6/drivers/s390/cio/css.h
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/css.h
+++ quilt-2.6/drivers/s390/cio/css.h
@@ -191,6 +191,5 @@ int sch_is_pseudo_sch(struct subchannel 
 
 extern struct workqueue_struct *slow_path_wq;
 
-int subchannel_add_files (struct device *);
 extern struct attribute_group *subch_attr_groups[];
 #endif

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

