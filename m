Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbYCaJJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbYCaJJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 05:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbYCaJIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 05:08:06 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55933 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991AbYCaJIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 05:08:04 -0400
Date: Mon, 31 Mar 2008 12:07:48 +0300
From: Adrian Bunk <bunk@kernel.org>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [2.6.25 patch] ide/ppc/pmac.c: add MODULE_LICENSE
Message-ID: <20080331090748.GH28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that it can be built modular it needs a MODULE_LICENSE.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
11eee3387e274e6152ed2f66d1f6d5a970b9ef62 diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 78c9eeb..d9ca52e 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1771,3 +1771,5 @@ static int __devinit pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 #endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */
 
 module_init(pmac_ide_probe);
+
+MODULE_LICENSE("GPL");

