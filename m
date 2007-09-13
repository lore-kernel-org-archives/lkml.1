Return-Path: <linux-kernel-owner+w=401wt.eu-S1763637AbXIMDkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763637AbXIMDkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 23:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757474AbXIMDkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 23:40:00 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37737 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbXIMDj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 23:39:59 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] update CFI URI n mtd kconfig
Date: Wed, 12 Sep 2007 23:39:54 -0400
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709122339.55267.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since AMD shunted its flash memory division, the URI in the mtd Kconfig is now
broken, so the attached patch points people to Wikipedia.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/drivers/mtd/chips/Kconfig b/drivers/mtd/chips/Kconfig
index 479d32b..980117a 100644
--- a/drivers/mtd/chips/Kconfig
+++ b/drivers/mtd/chips/Kconfig
@@ -11,8 +11,8 @@ config MTD_CFI
 	  AMD and other flash manufactures that provides a universal method
 	  for probing the capabilities of flash devices. If you wish to
 	  support any device that is CFI-compliant, you need to enable this
-	  option. Visit <http://www.amd.com/products/nvd/overview/cfi.html>
-	  for more information on CFI.
+	  option. For more information on CFI, visit:
+	  <http://wikipedia.org/wiki/Common_Flash_Memory_Interface>
 
 config MTD_JEDECPROBE
 	tristate "Detect non-CFI AMD/JEDEC-compatible flash chips"
