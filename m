Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbYJPRbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbYJPRbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756530AbYJPRPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:15:08 -0400
Received: from kroah.org ([198.145.64.141]:47049 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755670AbYJPRPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:15:07 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 44/46] UIO: Change driver name of uio_pdrv
Date: Thu, 16 Oct 2008 10:10:45 -0700
Message-Id: <1224177047-11859-44-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans J. Koch <hjk@linutronix.de>

The generic UIO platform device driver should be given a unique driver ID and
not just "uio". This is especially important since we now have a similar driver
named uio_pdrv_genirq. Currently, there's no user of this driver in the
mainline kernel.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio_pdrv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/uio/uio_pdrv.c b/drivers/uio/uio_pdrv.c
index 0b4ef39..d494ce9 100644
--- a/drivers/uio/uio_pdrv.c
+++ b/drivers/uio/uio_pdrv.c
@@ -12,7 +12,7 @@
 #include <linux/uio_driver.h>
 #include <linux/stringify.h>
 
-#define DRIVER_NAME "uio"
+#define DRIVER_NAME "uio_pdrv"
 
 struct uio_platdata {
 	struct uio_info *uioinfo;
-- 
1.6.0.2

