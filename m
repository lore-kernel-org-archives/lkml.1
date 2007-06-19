Return-Path: <linux-kernel-owner+w=401wt.eu-S934244AbXFSU0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934244AbXFSU0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934118AbXFSU00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:26:26 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33665 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934034AbXFSU0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:26:24 -0400
Date: Tue, 19 Jun 2007 22:26:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove the dead CYBERSTORMIII_SCSI option
Message-ID: <20070619202642.GF12950@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Not converted to the 2.6 kconfig system and no code in the tree.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc4-mm2/drivers/scsi/Kconfig.old	2007-06-18 15:22:55.000000000 +0200
+++ linux-2.6.22-rc4-mm2/drivers/scsi/Kconfig	2007-06-18 15:23:04.000000000 +0200
@@ -1774,8 +1774,6 @@
 	  To compile this driver as a module, choose M here: the
 	  module will be called esp.
 
-#      bool 'Cyberstorm Mk III SCSI support (EXPERIMENTAL)' CONFIG_CYBERSTORMIII_SCSI
-
 config ZFCP
 	tristate "FCP host bus adapter driver for IBM eServer zSeries"
 	depends on S390 && QDIO && SCSI

