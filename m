Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbXCYBam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbXCYBam (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 21:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbXCYBam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 21:30:42 -0400
Received: from mout1.freenet.de ([194.97.50.132]:56748 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298AbXCYBam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 21:30:42 -0400
Message-ID: <4605D0BA.2060801@freenet.de>
Date: Sun, 25 Mar 2007 03:30:34 +0200
From: Patrick Ringl <patrick_@freenet.de>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, axboe@kernel.dk
Subject: [PATCH] fix typo in drivers/block/Kconfig
Content-Type: multipart/mixed;
 boundary="------------040002040300080104070702"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040002040300080104070702
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,
this is just a QA / cosmetic fix .. nevertheless the documentation about
modules / drivers should be appropriate to the great work of those who
write all the real important stuff. :-)

The following patch is against 2.6.21-rc4:


--- linux-2.6.20-o/drivers/block/Kconfig	2007-03-18 00:04:53.000000000 +0100
+++ linux-2.6.20/drivers/block/Kconfig	2007-03-25 00:57:29.000000000 +0100
@@ -383,7 +383,7 @@
  	default "16"
  	depends on BLK_DEV_RAM
  	help
-	  The default value is 16 RAM disks. Change this if you know what
+	  The default value is 16 RAM disks. Change this if you know what you
  	  are doing. If you boot from a filesystem that needs to be extracted
  	  in memory, you will need at least one RAM disk (e.g. root on cramfs).



---

regards,
Patrick




--------------040002040300080104070702
Content-Type: text/plain;
 name="drivers_block_amount-of-ram-disks_typo_fix"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="drivers_block_amount-of-ram-disks_typo_fix"

--- linux-2.6.20-o/drivers/block/Kconfig	2007-03-18 00:04:53.000000000 +0100
+++ linux-2.6.20/drivers/block/Kconfig	2007-03-25 00:57:29.000000000 +0100
@@ -383,7 +383,7 @@
 	default "16"
 	depends on BLK_DEV_RAM
 	help
-	  The default value is 16 RAM disks. Change this if you know what
+	  The default value is 16 RAM disks. Change this if you know what you
 	  are doing. If you boot from a filesystem that needs to be extracted
 	  in memory, you will need at least one RAM disk (e.g. root on cramfs).
 

--------------040002040300080104070702--
