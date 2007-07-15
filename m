Return-Path: <linux-kernel-owner+w=401wt.eu-S1759386AbXGOUDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386AbXGOUDb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 16:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757225AbXGOUBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 16:01:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39940 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbXGOUBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 16:01:02 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] fallout from Auke's pci ->revision patch
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com
Message-Id: <E1IAAH8-000564-0G@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 15 Jul 2007 21:01:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/tulip/tulip_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/tulip/tulip_core.c b/drivers/net/tulip/tulip_core.c
index 7dcd138..f87d769 100644
--- a/drivers/net/tulip/tulip_core.c
+++ b/drivers/net/tulip/tulip_core.c
@@ -1274,7 +1274,7 @@ static int __devinit tulip_init_one (struct pci_dev *pdev,
 	if (pdev->vendor == 0x1282 && pdev->device == 0x9100)
 	{
 		/* Read Chip revision */
-		if (pdev->revision < 0x02000030)
+		if (pdev->revision < 0x30)
 		{
 			printk(KERN_ERR PFX "skipping early DM9100 with Crc bug (use dmfe)\n");
 			return -ENODEV;
-- 
1.5.3.GIT


