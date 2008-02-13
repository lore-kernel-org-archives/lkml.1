Return-Path: <linux-kernel-owner+w=401wt.eu-S934651AbYBMVqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934651AbYBMVqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764214AbYBMVbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:31:15 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50850 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764195AbYBMVbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:31:06 -0500
Date: Wed, 13 Feb 2008 23:30:50 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Surjit Reang <surjit.reang@neterion.com>,
       Sreenivasa Honnur <sreenivasa.honnur@neterion.com>,
       Ramkrishna Vepa <ram.vepa@neterion.com>, santosh.rastapur@neterion.com,
       sivakumar.subramani@neterion.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make s2io.c:init_tti() static
Message-ID: <20080213213050.GN3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global init_tti() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 30 Jan 2008

1e8c2b07be955b181814e4c24366517a66557908 
diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
index 5fab7d7..bc94e84 100644
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -1088,7 +1088,7 @@ static int s2io_print_pci_mode(struct s2io_nic *nic)
  *  '-1' on failure
  */
 
-int init_tti(struct s2io_nic *nic, int link)
+static int init_tti(struct s2io_nic *nic, int link)
 {
 	struct XENA_dev_config __iomem *bar0 = nic->bar0;
 	register u64 val64 = 0;

