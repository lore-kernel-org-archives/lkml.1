Return-Path: <linux-kernel-owner+w=401wt.eu-S2992740AbXCGXgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992740AbXCGXgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992743AbXCGXgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:36:10 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:46350 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992740AbXCGXgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:36:08 -0500
X-Originating-Ip: 74.109.98.130
Date: Wed, 7 Mar 2007 18:33:25 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: David Woodhouse <dwmw2@infradead.org>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] MTD: Correct misspelled preprocessor variable
 "MTD_NAND_DISKONCHIP_BBTWRITE".
Message-ID: <Pine.LNX.4.64.0703071831120.3827@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Replace the apparently misspelled preprocessor variable
"MTD_NAND_DISKONCHIP_BBTWRITE" with the correct form
"CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE".

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
index 12608c1..595208f 100644
--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -114,7 +114,7 @@ module_param(no_autopart, int, 0);
 static int show_firmware_partition = 0;
 module_param(show_firmware_partition, int, 0);

-#ifdef MTD_NAND_DISKONCHIP_BBTWRITE
+#ifdef CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE
 static int inftl_bbt_write = 1;
 #else
 static int inftl_bbt_write = 0;

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
