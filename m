Return-Path: <linux-kernel-owner+w=401wt.eu-S1758101AbXJDL3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbXJDL3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbXJDL23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:28:29 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:25462 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbXJDL2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:28:23 -0400
Message-Id: <20071004112825.043551769@de.ibm.com>
References: <20071004112706.574737175@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Oct 2007 13:27:08 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 02/34] cio: remove subchannel_add_files()
Content-Disposition: inline; filename=002-cio-remove.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

subchannel_add_files() no longer exists, remove from header.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
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

