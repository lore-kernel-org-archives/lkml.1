Return-Path: <linux-kernel-owner+w=401wt.eu-S934677AbXFFFrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934677AbXFFFrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 01:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755872AbXFFFrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 01:47:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906AbXFFFrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 01:47:04 -0400
Date: Wed, 6 Jun 2007 01:46:47 -0400
From: Dave Jones <davej@redhat.com>
To: dwmw2@infradead.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: remove references to dead urls from mtd nand code.
Message-ID: <20070606054647.GA20850@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, dwmw2@infradead.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As reported in http://bugzilla.kernel.org/show_bug.cgi?id=7815
this URL 404's.  Unless they're coming back, we should probably
just remove them.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index f1d60b6..8f665bb 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -7,8 +7,7 @@ menuconfig MTD_NAND
 	select MTD_NAND_IDS
 	help
 	  This enables support for accessing all type of NAND flash
-	  devices. For further information see
-	  <http://www.linux-mtd.infradead.org/doc/nand.html>.
+	  devices.
 
 if MTD_NAND
 
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 7e68203..3f406c7 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -6,9 +6,6 @@
  *   capable of working with almost all NAND chips currently available.
  *   Basic support for AG-AND chips is provided.
  *
- *	Additional technical information is available on
- *	http://www.linux-mtd.infradead.org/tech/nand.html
- *
  *  Copyright (C) 2000 Steven J. Hill (sjhill@realitydiluted.com)
  *		  2002-2006 Thomas Gleixner (tglx@linutronix.de)
  *
-- 
http://www.codemonkey.org.uk
