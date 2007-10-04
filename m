Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbXJDEO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbXJDEO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 00:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbXJDEOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 00:14:16 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:11533 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbXJDEOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 00:14:14 -0400
Date: Wed, 03 Oct 2007 22:13:18 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 1/3] Sysace: Minor coding convention fixup
In-reply-to: <20071004041114.20868.34605.stgit@trillian.cg.shawcable.net>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Message-id: <20071004041318.20868.51928.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20071004041114.20868.34605.stgit@trillian.cg.shawcable.net>
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Put function call and return code test on separate lines.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/block/xsysace.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 3ea172b..3847464 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -1091,7 +1091,8 @@ ace_alloc(struct device *dev, int id, unsigned long physaddr,
 	ace->bus_width = bus_width;
 
 	/* Call the setup code */
-	if ((rc = ace_setup(ace)) != 0)
+	rc = ace_setup(ace);
+	if (rc)
 		goto err_setup;
 
 	dev_set_drvdata(dev, ace);
@@ -1253,11 +1254,13 @@ static int __init ace_init(void)
 		goto err_blk;
 	}
 
-	if ((rc = ace_of_register()) != 0)
+	rc = ace_of_register();
+	if (rc)
 		goto err_of;
 
 	pr_debug("xsysace: registering platform binding\n");
-	if ((rc = platform_driver_register(&ace_platform_driver)) != 0)
+	rc = platform_driver_register(&ace_platform_driver);
+	if (rc)
 		goto err_plat;
 
 	pr_info("Xilinx SystemACE device driver, major=%i\n", ace_major);

