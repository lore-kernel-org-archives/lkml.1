Return-Path: <linux-kernel-owner+w=401wt.eu-S2992433AbXBIQnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992433AbXBIQnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946654AbXBIQjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:39:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51722 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946659AbXBIQjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:39:32 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] ahci: trivial endianness annotations
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Message-Id: <E1HFYmY-0006px-NW@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:39:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/ata/ahci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 48616c6..e2796fb 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1173,7 +1173,7 @@ static void ahci_host_intr(struct ata_port *ap)
 		 * dangerous, we need to know more about them.  Print
 		 * more of it.
 		 */
-		const u32 *f = pp->rx_fis + RX_FIS_SDB;
+		const __le32 *f = pp->rx_fis + RX_FIS_SDB;
 
 		ata_port_printk(ap, KERN_INFO, "Spurious SDB FIS during NCQ "
 				"issue=0x%x SAct=0x%x FIS=%08x:%08x%s\n",
-- 
1.5.0-rc2.GIT


