Return-Path: <linux-kernel-owner+w=401wt.eu-S933244AbXGaSEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244AbXGaSEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763183AbXGaSEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:04:32 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3467 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761307AbXGaSEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:04:30 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 33] fs/reiser4/init_super.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 20:04:29 +0200
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
Message-Id: <200707312004.29404.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 fs/reiser4/init_super.c | 19283 -> 19246 (-37 bytes)
 fs/reiser4/init_super.o | 155348 -> 155152 (-196 bytes)

 fs/reiser4/init_super.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1-a/fs/reiser4/init_super.c	2007-07-26 13:07:46.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/fs/reiser4/init_super.c	2007-07-30 00:00:32.000000000 +0200
@@ -17,14 +17,13 @@ int reiser4_init_fs_info(struct super_bl
 {
 	reiser4_super_info_data *sbinfo;

-	sbinfo = kmalloc(sizeof(reiser4_super_info_data),
+	sbinfo = kzalloc(sizeof(reiser4_super_info_data),
 			 reiser4_ctx_gfp_mask_get());
 	if (!sbinfo)
 		return RETERR(-ENOMEM);

 	super->s_fs_info = sbinfo;
 	super->s_op = NULL;
-	memset(sbinfo, 0, sizeof(*sbinfo));

 	ON_DEBUG(INIT_LIST_HEAD(&sbinfo->all_jnodes));
 	ON_DEBUG(spin_lock_init(&sbinfo->all_guard));
