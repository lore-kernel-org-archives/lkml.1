Return-Path: <linux-kernel-owner+w=401wt.eu-S1763690AbXGaRQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763690AbXGaRQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756469AbXGaRQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:16:15 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1832 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbXGaRQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:16:14 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 12] fs/reiser4/plugin/file/cryptcompress.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 19:16:13 +0200
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
Message-Id: <200707311916.13506.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 fs/reiser4/plugin/file/cryptcompress.c | 101386 -> 101352 (-34 bytes)
 fs/reiser4/plugin/file/cryptcompress.o | 456784 -> 456644 (-140 bytes)

 fs/reiser4/plugin/file/cryptcompress.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm1-a/fs/reiser4/plugin/file/cryptcompress.c	2007-07-26 13:07:46.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/fs/reiser4/plugin/file/cryptcompress.c	2007-07-31 15:00:24.000000000 +0200
@@ -74,13 +74,13 @@ static void set_inode_crypto_info (struc
 /* allocate a cipher key info */
 struct reiser4_crypto_info * reiser4_alloc_crypto_info (struct inode * inode)
 {
-	struct reiser4_crypto_info * info;
+	struct reiser4_crypto_info *info;
 	int fipsize;

-	info = kmalloc(sizeof(*info), reiser4_ctx_gfp_mask_get());
+	info = kzalloc(sizeof(*info), reiser4_ctx_gfp_mask_get());
 	if (!info)
 		return ERR_PTR(-ENOMEM);
-	memset(info, 0, sizeof (*info));
+
 	fipsize = inode_digest_plugin(inode)->fipsize;
 	info->keyid = kmalloc(fipsize, reiser4_ctx_gfp_mask_get());
 	if (!info->keyid) {
