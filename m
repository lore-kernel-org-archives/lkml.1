Return-Path: <linux-kernel-owner+w=401wt.eu-S1762298AbXHTWxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762298AbXHTWxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757796AbXHTWwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:52:38 -0400
Received: from ns2.suse.de ([195.135.220.15]:53936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757520AbXHTWwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:52:37 -0400
Message-Id: <20070820225101.782694000@suse.de>
References: <20070820224806.154198000@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 20 Aug 2007 15:48:10 -0700
From: tonyj@suse.de
To: linux-kernel@vger.kernel.org
Cc: funaho@jurai.org, benh@kernel.crashing.org, kay.sievers@vrfy.org
Subject: [patch 04/14] Convert from class_device to device for drivers/macintosh
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-- 
Content-Disposition: inline; filename=macintosh.patch

Convert from class_device to device for macintosh.  This is part of the
work to eliminate struct class_device.

---
 drivers/macintosh/adb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -875,5 +875,5 @@ adbdev_init(void)
 	adb_dev_class = class_create(THIS_MODULE, "adb");
 	if (IS_ERR(adb_dev_class))
 		return;
-	class_device_create(adb_dev_class, NULL, MKDEV(ADB_MAJOR, 0), NULL, "adb");
+	device_create(adb_dev_class, NULL, MKDEV(ADB_MAJOR, 0), "adb");
 }

-- 
