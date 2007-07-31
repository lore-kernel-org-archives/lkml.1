Return-Path: <linux-kernel-owner+w=401wt.eu-S1763690AbXGaRUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763690AbXGaRUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbXGaRUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:20:00 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3471 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbXGaRT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:19:58 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 14] kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 19:19:57 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       reiserfs-dev@namesys.com, reiserfs-devel@vger.kernel.org
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311919.58196.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 fs/reiser4/plugin/item/ctail.c | 41897 -> 41859 (-38 bytes)
 fs/reiser4/plugin/item/ctail.o | 306180 -> 305904 (-276 bytes)

 fs/reiser4/plugin/item/ctail.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1-a/fs/reiser4/plugin/item/ctail.c	2007-07-26 13:07:46.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/fs/reiser4/plugin/item/ctail.c	2007-07-31 15:03:52.000000000 +0200
@@ -1148,10 +1148,10 @@ static int alloc_convert_data(flush_pos_
 	assert("edward-821", pos != NULL);
 	assert("edward-822", pos->sq == NULL);

-	pos->sq = kmalloc(sizeof(*pos->sq), reiser4_ctx_gfp_mask_get());
+	pos->sq = kzalloc(sizeof(*pos->sq), reiser4_ctx_gfp_mask_get());
 	if (!pos->sq)
 		return RETERR(-ENOMEM);
-	memset(pos->sq, 0, sizeof(*pos->sq));
+
 	cluster_init_write(&pos->sq->clust, NULL);
 	return 0;
 }
