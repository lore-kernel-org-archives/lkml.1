Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbZDFNLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbZDFNLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 09:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbZDFNLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 09:11:01 -0400
Received: from 81-7-68-229.static.zebra.lt ([81.7.68.229]:59004 "EHLO
	teltonika.lt" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753894AbZDFNLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 09:11:00 -0400
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: [PATCH] mtd: fix Kconfig comment about 'armflash'
To: linux-mtd@lists.infradead.org, trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Mon, 06 Apr 2009 16:10:54 +0300
Message-ID: <20090406131054.16163.11343.stgit@Programuotojas>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The real 'armflash' map driver is selected by CONFIG_MTD_ARM_INTEGRATOR

Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
---

 drivers/mtd/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index 7d04fb9..b8e35a0 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -154,7 +154,8 @@ config MTD_AFS_PARTS
 
 	  You will still need the parsing functions to be called by the driver
 	  for your particular device. It won't happen automatically. The
-	  'armflash' map driver (CONFIG_MTD_ARMFLASH) does this, for example.
+	  'armflash' map driver (CONFIG_MTD_ARM_INTEGRATOR) does this, for
+	  example.
 
 config MTD_OF_PARTS
 	tristate "Flash partition map based on OF description"

