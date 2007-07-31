Return-Path: <linux-kernel-owner+w=401wt.eu-S1762061AbXGaNLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762061AbXGaNLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759977AbXGaNJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:09:56 -0400
Received: from host86-137-100-191.range86-137.btcentralplus.com ([86.137.100.191]:42959
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761733AbXGaNJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:09:54 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 09:09:04 EDT
From: jack@hawkeye.stone.uk.eu.org
Message-Id: <20070731125446.578465000@hawkeye.stone.uk.eu.org>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
User-Agent: quilt/0.46-1
Date: Tue, 31 Jul 2007 13:53:30 +0100
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Daniel Drake <dsd@gentoo.org>
Subject: [Patch 14/16] Remove needless kmalloc casts in the zd1211rw drivers.
Content-Disposition: inline; filename=drivers_net_wireless_zd1211rw_remove_kmalloc_casts.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>

CC: Daniel Drake <dsd@gentoo.org>

---
 drivers/net/wireless/zd1211rw/zd_chip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/net/wireless/zd1211rw/zd_chip.c
===================================================================
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -115,7 +115,7 @@ int zd_ioread32v_locked(struct zd_chip *
 
 	/* Allocate a single memory block for values and addresses. */
 	count16 = 2*count;
-	a16 = (zd_addr_t *) kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
+	a16 = kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
 		                   GFP_KERNEL);
 	if (!a16) {
 		dev_dbg_f(zd_chip_dev(chip),

-- 
