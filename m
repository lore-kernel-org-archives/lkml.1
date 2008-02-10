Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbYBJDjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbYBJDjj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 22:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbYBJDja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 22:39:30 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:58330 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753200AbYBJDj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 22:39:29 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Silent compiler warning introduced by commit 801c135ce73d5df1caf3eca35b66a10824ae0707 (UBI: Unsorted Block Images)
Date: Sun, 10 Feb 2008 05:37:44 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20080201.769323)
Cc: dedekind@linutronix.de, haver@vnet.ibm.com, torvalds@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802100537.47634.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

Following patch silents

drivers/mtd/ubi/vmt.c: In function `ubi_create_volume':
drivers/mtd/ubi/vmt.c:379: warning: statement with no effect

compiler warning introduced by commit 801c135ce73d5df1caf3eca35b66a10824ae0707 (UBI: Unsorted Block Images)

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

 drivers/mtd/ubi/vmt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index a3ca225..eafeaf0 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -376,7 +376,7 @@ out_sysfs:
 	get_device(&vol->dev);
 	volume_sysfs_close(vol);
 out_gluebi:
-	ubi_destroy_gluebi(vol);
+	err = ubi_destroy_gluebi(vol);
 out_cdev:
 	cdev_del(&vol->cdev);
 out_mapping:

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
