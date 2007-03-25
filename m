Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbXCYBjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbXCYBjb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 21:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbXCYBjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 21:39:31 -0400
Received: from mout2.freenet.de ([194.97.50.155]:59919 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312AbXCYBja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 21:39:30 -0400
Message-ID: <4605D2CA.5070607@freenet.de>
Date: Sun, 25 Mar 2007 03:39:22 +0200
From: Patrick Ringl <patrick_@freenet.de>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, axboe@kernel.dk
Subject: [PATCH UPDATED] fix typo in drivers/block/Kconfig
Content-Type: multipart/mixed;
 boundary="------------090302090501010409090502"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090302090501010409090502
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

[ ... Fixed two minor typos. ...]

The following patch is against 2.6.21-rc4:


--- linux-2.6.20-o/drivers/block/Kconfig	2007-03-18 00:04:53.000000000 +0100
+++ linux-2.6.20/drivers/block/Kconfig	2007-03-25 03:35:19.000000000 +0200
@@ -383,7 +383,7 @@
  	default "16"
  	depends on BLK_DEV_RAM
  	help
-	  The default value is 16 RAM disks. Change this if you know what
+	  The default value is 16 RAM disks. Change this if you know what you
  	  are doing. If you boot from a filesystem that needs to be extracted
  	  in memory, you will need at least one RAM disk (e.g. root on cramfs).

@@ -393,7 +393,7 @@
  	default "4096"
  	help
  	  The default value is 4096 kilobytes. Only change this if you know
-	  what are you doing. If you are using IBM S/390, then set this to
+	  what you are doing. If you are using IBM S/390, then set this to
  	  8192.

  config BLK_DEV_RAM_BLOCKSIZE




---

regards,
Patrick





--------------090302090501010409090502
Content-Type: text/plain;
 name="drivers_block_amount-of-ram-disks_typo_fix2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="drivers_block_amount-of-ram-disks_typo_fix2"

--- linux-2.6.20-o/drivers/block/Kconfig	2007-03-18 00:04:53.000000000 +0100
+++ linux-2.6.20/drivers/block/Kconfig	2007-03-25 03:35:19.000000000 +0200
@@ -383,7 +383,7 @@
 	default "16"
 	depends on BLK_DEV_RAM
 	help
-	  The default value is 16 RAM disks. Change this if you know what
+	  The default value is 16 RAM disks. Change this if you know what you
 	  are doing. If you boot from a filesystem that needs to be extracted
 	  in memory, you will need at least one RAM disk (e.g. root on cramfs).
 
@@ -393,7 +393,7 @@
 	default "4096"
 	help
 	  The default value is 4096 kilobytes. Only change this if you know
-	  what are you doing. If you are using IBM S/390, then set this to
+	  what you are doing. If you are using IBM S/390, then set this to
 	  8192.
 
 config BLK_DEV_RAM_BLOCKSIZE

--------------090302090501010409090502--
