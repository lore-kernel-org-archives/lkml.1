Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541AbZDUOXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbZDUOXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZDUOW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:22:56 -0400
Received: from xenotime.net ([72.52.64.118]:38255 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751124AbZDUOWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:22:55 -0400
Message-ID: <49EDD6BD.1010006@xenotime.net>
Date: Tue, 21 Apr 2009 07:22:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
Subject: [PATCH] platform: fix kernel-doc warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix function parameter notation in platform.c;
fixes kernel-doc warnings.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/base/platform.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.30-rc2-git6.orig/drivers/base/platform.c
+++ linux-2.6.30-rc2-git6/drivers/base/platform.c
@@ -1028,7 +1028,7 @@ static __initdata LIST_HEAD(early_platfo
 
 /**
  * early_platform_driver_register
- * @edrv: early_platform driver structure
+ * @epdrv: early_platform driver structure
  * @buf: string passed from early_param()
  */
 int __init early_platform_driver_register(struct early_platform_driver *epdrv,
@@ -1112,7 +1112,7 @@ void __init early_platform_driver_regist
 
 /**
  * early_platform_match
- * @edrv: early platform driver structure
+ * @epdrv: early platform driver structure
  * @id: id to match against
  */
 static  __init struct platform_device *
@@ -1130,7 +1130,7 @@ early_platform_match(struct early_platfo
 
 /**
  * early_platform_left
- * @edrv: early platform driver structure
+ * @epdrv: early platform driver structure
  * @id: return true if id or above exists
  */
 static  __init int early_platform_left(struct early_platform_driver *epdrv,
