Return-Path: <linux-kernel-owner+w=401wt.eu-S2992688AbXCGWlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992688AbXCGWlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992700AbXCGWlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:41:18 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52715 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992688AbXCGWlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:41:11 -0500
Date: Wed, 7 Mar 2007 23:41:11 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org
Subject: [RFC: -mm patch] #if 0 mmc_deselect_cards()
Message-ID: <20070307224111.GD3441@stusta.de>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070306004408.d3f6434d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 12:44:08AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc2-mm1:
>...
>  git-mmc.patch
>...
>  git trees
>...

mmc_deselect_cards() is no longer used.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/mmc/core/mmc_ops.c |    2 ++
 drivers/mmc/core/mmc_ops.h |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.21-rc2-mm2/drivers/mmc/core/mmc_ops.h.old	2007-03-07 00:55:48.000000000 +0100
+++ linux-2.6.21-rc2-mm2/drivers/mmc/core/mmc_ops.h	2007-03-07 00:55:54.000000000 +0100
@@ -13,7 +13,6 @@
 #define _MMC_MMC_OPS_H
 
 int mmc_select_card(struct mmc_card *card);
-int mmc_deselect_cards(struct mmc_host *host);
 int mmc_go_idle(struct mmc_host *host);
 int mmc_send_op_cond(struct mmc_host *host, u32 ocr, u32 *rocr);
 int mmc_all_send_cid(struct mmc_host *host, u32 *cid);
--- linux-2.6.21-rc2-mm2/drivers/mmc/core/mmc_ops.c.old	2007-03-07 00:56:00.000000000 +0100
+++ linux-2.6.21-rc2-mm2/drivers/mmc/core/mmc_ops.c	2007-03-07 00:56:22.000000000 +0100
@@ -53,10 +53,12 @@
 	return _mmc_select_card(card->host, card);
 }
 
+#if 0
 int mmc_deselect_cards(struct mmc_host *host)
 {
 	return _mmc_select_card(host, NULL);
 }
+#endif  /*  0  */
 
 int mmc_go_idle(struct mmc_host *host)
 {

