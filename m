Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbYHSTO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbYHSTO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbYHSTOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:14:45 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:25439 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbYHSTOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:14:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=jOTLhp9GYGndzt2UORSJR4CYHzl1baDQtHqfiXoPbijnjogMGOHrs1UTOnRfv8ZRuR
         WVlGBI0RK0+Jqkb9YsL5w0qmRCUocjvI986L7p6T+0ouU20aANnEOyssM+97HQ7qAXgJ
         UdysmxmgO8z3OXXO93HwAVeLsCTgH1+x2NU9I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide/Kconfig: mark ide-scsi as deprecated
Date: Tue, 19 Aug 2008 21:11:44 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808192111.45351.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark ide-scsi as deprecated and remove stale/bogus documentation.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -187,7 +187,7 @@ config BLK_DEV_IDEFLOPPY
 	  module will be called ide-floppy.
 
 config BLK_DEV_IDESCSI
-	tristate "SCSI emulation support"
+	tristate "SCSI emulation support (DEPRECATED)"
 	depends on SCSI
 	select IDE_ATAPI
 	---help---
@@ -200,20 +200,6 @@ config BLK_DEV_IDESCSI
 	  and will allow you to use a SCSI device driver instead of a native
 	  ATAPI driver.
 
-	  This is useful if you have an ATAPI device for which no native
-	  driver has been written (for example, an ATAPI PD-CD drive);
-	  you can then use this emulation together with an appropriate SCSI
-	  device driver. In order to do this, say Y here and to "SCSI support"
-	  and "SCSI generic support", below. You must then provide the kernel
-	  command line "hdx=ide-scsi" (try "man bootparam" or see the
-	  documentation of your boot loader (lilo or loadlin) about how to
-	  pass options to the kernel at boot time) for devices if you want the
-	  native EIDE sub-drivers to skip over the native support, so that
-	  this SCSI emulation can be used instead.
-
-	  Note that this option does NOT allow you to attach SCSI devices to a
-	  box that doesn't have a SCSI host adapter installed.
-
 	  If both this SCSI emulation and native ATAPI support are compiled
 	  into the kernel, the native support will be used.
 
