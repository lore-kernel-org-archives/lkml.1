Return-Path: <linux-kernel-owner+w=401wt.eu-S1758344AbZEID3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344AbZEID3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 23:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757404AbZEID3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 23:29:09 -0400
Received: from kroah.org ([198.145.64.141]:41355 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757354AbZEID3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 23:29:07 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/5] Driver core: platform: fix kernel-doc warnings
Date: Fri,  8 May 2009 20:25:55 -0700
Message-Id: <1241839559-9157-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090509032432.GA9000@kroah.com>
References: <20090509032432.GA9000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix function parameter notation in platform.c;
fixes kernel-doc warnings.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index b5b6c97..ec5400c 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -1028,7 +1028,7 @@ static __initdata LIST_HEAD(early_platform_device_list);
 
 /**
  * early_platform_driver_register
- * @edrv: early_platform driver structure
+ * @epdrv: early_platform driver structure
  * @buf: string passed from early_param()
  */
 int __init early_platform_driver_register(struct early_platform_driver *epdrv,
@@ -1112,7 +1112,7 @@ void __init early_platform_driver_register_all(char *class_str)
 
 /**
  * early_platform_match
- * @edrv: early platform driver structure
+ * @epdrv: early platform driver structure
  * @id: id to match against
  */
 static  __init struct platform_device *
@@ -1130,7 +1130,7 @@ early_platform_match(struct early_platform_driver *epdrv, int id)
 
 /**
  * early_platform_left
- * @edrv: early platform driver structure
+ * @epdrv: early platform driver structure
  * @id: return true if id or above exists
  */
 static  __init int early_platform_left(struct early_platform_driver *epdrv,
-- 
1.6.3

