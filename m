Return-Path: <linux-kernel-owner+w=401wt.eu-S1758297AbZLNV4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297AbZLNV4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757554AbZLNV4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:56:22 -0500
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:39565 "EHLO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633AbZLNV4W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:56:22 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/mtd/nand/s3c2410.c: use resource_size()
Date: Mon, 14 Dec 2009 16:56:22 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA66@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/mtd/nand/s3c2410.c: use resource_size()
Thread-Index: Acp9CEYtYtz7pyviTnaWHuSZ/kFplw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       <linux-mtd@lists.infradead.org>
Cc: "David Woodhouse" <dwmw2@infradead.org>, "Ben Dooks" <ben-linux@fluff.org>
X-OriginalArrivalTime: 14 Dec 2009 21:56:20.0762 (UTC) FILETIME=[45325FA0:01CA7D08]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Ben Dooks <ben-linux@fluff.org>

---

diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
index 68b5b3a..3b5a8cc 100644
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -957,7 +957,7 @@ static int s3c24xx_nand_probe(struct platform_device *pdev)
 
 	/* currently we assume we have the one resource */
 	res  = pdev->resource;
-	size = res->end - res->start + 1;
+	size = resource_size(res);
 
 	info->area = request_mem_region(res->start, size, pdev->name);
  
