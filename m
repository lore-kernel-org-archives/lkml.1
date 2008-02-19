Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbYBSOp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbYBSOp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbYBSOpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:45:12 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:39966 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbYBSOpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:45:08 -0500
Message-Id: <20080219144502.901113484@de.ibm.com>
References: <20080219144047.587547541@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 19 Feb 2008 15:40:48 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 01/13] cio: Remember to initialize recovery_lock.
Content-Disposition: inline; filename=001-cio-lockinit.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: quilt-2.6/drivers/s390/cio/device.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/device.c
+++ quilt-2.6/drivers/s390/cio/device.c
@@ -32,7 +32,7 @@
 #include "io_sch.h"
 
 static struct timer_list recovery_timer;
-static spinlock_t recovery_lock;
+static DEFINE_SPINLOCK(recovery_lock);
 static int recovery_phase;
 static const unsigned long recovery_delay[] = { 3, 30, 300 };
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

