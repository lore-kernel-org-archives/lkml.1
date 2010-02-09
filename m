Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab0BIWmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 17:42:23 -0500
Received: from smtp.getmail.no ([84.208.15.66]:41714 "EHLO
	get-mta-out02.get.basefarm.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751539Ab0BIWmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 17:42:21 -0500
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Feb 2010 17:42:21 EST
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
X-PMX-Version: 5.5.3.366731, Antispam-Engine: 2.7.0.366912,
 Antispam-Data: 2010.2.9.212416
From: Cosimo Streppone <cosimo@cpan.org>
To: "James E . J . Bottomley" <James.Bottomley@suse.de>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Cosimo Streppone <cosimo@cpan.org>
Subject: [PATCH] scsi: zorro7xx: braces code style fix
Date: Tue, 09 Feb 2010 22:41:43 +0100
Message-id: <1265751703-25745-1-git-send-email-cosimo@cpan.org>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a tiny coding style fix for the scsi/zorro7xx.c file.
FOSDEM GregKH talk helped this patch come to life.

Signed-off-by: Cosimo Streppone <cosimo@cpan.org>
---
 drivers/scsi/zorro7xx.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index 64d40a2..a666f20 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -80,11 +80,10 @@ static int __devinit zorro7xx_init_one(struct zorro_dev *z,
 	board = zorro_resource_start(z);
 	zdd = (struct zorro_driver_data *)ent->driver_data;
 
-	if (zdd->absolute) {
+	if (zdd->absolute)
 		ioaddr = zdd->offset;
-	} else {
+	else
 		ioaddr = board + zdd->offset;
-	}
 
 	if (!zorro_request_device(z, zdd->name)) {
 		printk(KERN_ERR "zorro7xx: cannot reserve region 0x%lx, abort\n",
-- 
1.6.0.4

