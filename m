Return-Path: <linux-kernel-owner+w=401wt.eu-S1760897AbYA1WLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897AbYA1WLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759755AbYA1WJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:09:54 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46406 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757563AbYA1WJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:09:53 -0500
Date: Tue, 29 Jan 2008 00:10:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] ata_piix.c: make piix_merge_scr() static
Message-ID: <20080128221019.GN8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

piix_merge_scr() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
f272ad2ac4274a59f0b43cfd65488c51855132d4 
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index a65c8ae..1a5c3bf 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1068,7 +1068,7 @@ static void piix_sidpr_write(struct ata_device *dev, unsigned int reg, u32 val)
 	iowrite32(val, hpriv->sidpr + PIIX_SIDPR_DATA);
 }
 
-u32 piix_merge_scr(u32 val0, u32 val1, const int * const *merge_tbl)
+static u32 piix_merge_scr(u32 val0, u32 val1, const int * const *merge_tbl)
 {
 	u32 val = 0;
 	int i, mi;

