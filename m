Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbXJAOUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbXJAOUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 10:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbXJAOUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 10:20:12 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:17877 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbXJAOUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 10:20:10 -0400
Date: Mon, 01 Oct 2007 08:19:10 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] Sysace: Labels in C code should not be indented.
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Message-id: <20071001141818.22465.46885.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Remove the indentation on labels

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Jens,

Here's the unindent of labels fixup patch that I promised you.  Please
apply after applying the SystemACE series.

Thanks,
g.

 drivers/block/xsysace.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 77bd805..3847464 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -1034,13 +1034,13 @@ static int __devinit ace_setup(struct ace_device *ace)
 
 	return 0;
 
-      err_read:
+err_read:
 	put_disk(ace->gd);
-      err_alloc_disk:
+err_alloc_disk:
 	blk_cleanup_queue(ace->queue);
-      err_blk_initq:
+err_blk_initq:
 	iounmap(ace->baseaddr);
-      err_ioremap:
+err_ioremap:
 	dev_info(ace->dev, "xsysace: error initializing device at 0x%lx\n",
 	       ace->physaddr);
 	return -ENOMEM;
@@ -1098,11 +1098,11 @@ ace_alloc(struct device *dev, int id, unsigned long physaddr,
 	dev_set_drvdata(dev, ace);
 	return 0;
 
-      err_setup:
+err_setup:
 	dev_set_drvdata(dev, NULL);
 	kfree(ace);
-      err_alloc:
-      err_noreg:
+err_alloc:
+err_noreg:
 	dev_err(dev, "could not initialize device, err=%i\n", rc);
 	return rc;
 }
@@ -1266,11 +1266,11 @@ static int __init ace_init(void)
 	pr_info("Xilinx SystemACE device driver, major=%i\n", ace_major);
 	return 0;
 
-      err_plat:
+err_plat:
 	ace_of_unregister();
-      err_of:
+err_of:
 	unregister_blkdev(ace_major, "xsysace");
-      err_blk:
+err_blk:
 	printk(KERN_ERR "xsysace: registration failed; err=%i\n", rc);
 	return rc;
 }

