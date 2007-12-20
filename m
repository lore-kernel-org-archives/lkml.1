Return-Path: <linux-kernel-owner+w=401wt.eu-S1760877AbXLTBoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877AbXLTBoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758345AbXLTBfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:35:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:12879 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758365AbXLTBfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:35:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=OFUsh06X9iw/WrMDkdrx56XI+ZTer38g9KZzsO8qsQYF120hnGAGttPrSEOhRy01u2fnTUsFPAWp/RqJP+jBpmTiQEQori65/14SF8PYIv2RztUsPLMbsMEBvJk51cG9aV8JAlSZXGkqDs8hgEyrDTiSiLrJX6YdFKY0+Ps9sXM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 63/63] ide-cd: update driver version, comments and copyrights
Date: Thu, 20 Dec 2007 02:40:20 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200240.21077.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bump driver version.

* Remove filename and stale TODO from comments.

* Add my copyrights.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1,14 +1,14 @@
 /*
- * linux/drivers/ide/ide-cd.c
+ * ATAPI CD-ROM driver.
  *
- * Copyright (C) 1994, 1995, 1996  scott snyder  <snyder@fnald0.fnal.gov>
+ * Copyright (C) 1994-1996  Scott Snyder <snyder@fnald0.fnal.gov>
  * Copyright (C) 1996-1998  Erik Andersen <andersee@debian.org>
  * Copyright (C) 1998-2000  Jens Axboe <axboe@suse.de>
+ * Copyright (C)      2007  Bartlomiej Zolnierkiewicz
  *
  * May be copied or modified under the terms of the GNU General Public
  * License.  See linux/COPYING for more information.
  *
- * ATAPI CD-ROM driver.  To be used with ide.c.
  * See Documentation/cdrom/ide-cd for usage information.
  *
  * Suggestions are welcome. Patches that work are more welcome though. ;-)
@@ -19,20 +19,11 @@
  * ftp://fission.dt.wdc.com/pub/standards/SFF_atapi/spec/SFF8020-r2.6/PS/8020r26.ps
  * ftp://ftp.avc-pioneer.com/Mtfuji4/Spec/Fuji4r10.pdf
  *
- * Drives that deviate from these standards will be accommodated as much
- * as possible via compile time or command-line options.  Since I only have
- * a few drives, you generally need to send me patches...
- *
- * ----------------------------------
- * TO DO LIST:
- * -Make it so that Pioneer CD DR-A24X and friends don't get screwed up on
- *   boot
- *
  * For historical changelog please see:
  *	Documentation/ide/ChangeLog.ide-cd.1994-2004
  */
 
-#define IDECD_VERSION "4.61"
+#define IDECD_VERSION "5.00"
 
 #include <linux/module.h>
 #include <linux/types.h>
