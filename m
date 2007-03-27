Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387AbXC0Tbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbXC0Tbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 15:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbXC0Tbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 15:31:41 -0400
Received: from mout0.freenet.de ([194.97.50.131]:44108 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbXC0Tbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 15:31:40 -0400
Message-ID: <46097117.3040007@freenet.de>
Date: Tue, 27 Mar 2007 21:31:35 +0200
From: Patrick Ringl <patrick_@freenet.de>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, jens.axboe@oracle.com
Subject: [PATCH UPDATED] fix typo in drivers/block/Kconfig
Content-Type: multipart/mixed;
 boundary="------------060705070907000107060103"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060705070907000107060103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

[ ... Fixed two minor typos. ...]

The following patch (it's also attached tho) is against 2.6.21-rc5 :


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






--------------060705070907000107060103
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


--------------060705070907000107060103--
