Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbYFJQOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbYFJQOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 12:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbYFJQOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 12:14:06 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:17782 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbYFJQOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 12:14:05 -0400
Date: Tue, 10 Jun 2008 11:14:04 -0500
From: Mike Miller <mike.miller@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LKML-scsi <linux-scsi@vger.kernel.org>, andrew.patterson@hp.com,
       justin.chen@hp.com
Subject: [PATCH 2/2] cciss: bump version to .20 to reflect new HW support
Message-ID: <20080610161404.GB6808@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PATCH 2/2
This patch bumps the driver version to 3.6.20 to reflect the new hardware
support from patch 1 of this set. Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index ced904d..c21a5a9 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -53,16 +53,16 @@
 #include <linux/scatterlist.h>
 
 #define CCISS_DRIVER_VERSION(maj,min,submin) ((maj<<16)|(min<<8)|(submin))
-#define DRIVER_NAME "HP CISS Driver (v 3.6.14)"
-#define DRIVER_VERSION CCISS_DRIVER_VERSION(3,6,14)
+#define DRIVER_NAME "HP CISS Driver (v 3.6.20)"
+#define DRIVER_VERSION CCISS_DRIVER_VERSION(3, 6, 20)
 
 /* Embedded module documentation macros - see modules.h */
 MODULE_AUTHOR("Hewlett-Packard Company");
-MODULE_DESCRIPTION("Driver for HP Controller SA5xxx SA6xxx version 3.6.14");
+MODULE_DESCRIPTION("Driver for HP Smart Array Controllers");
 MODULE_SUPPORTED_DEVICE("HP SA5i SA5i+ SA532 SA5300 SA5312 SA641 SA642 SA6400"
 			" SA6i P600 P800 P400 P400i E200 E200i E500 P700m"
 			" Smart Array G2 Series SAS/SATA Controllers");
-MODULE_VERSION("3.6.14");
+MODULE_VERSION("3.6.20");
 MODULE_LICENSE("GPL");
 
 #include "cciss_cmd.h"
