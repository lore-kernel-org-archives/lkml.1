Return-Path: <linux-kernel-owner+w=401wt.eu-S1759532AbXGAUYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532AbXGAUYi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758481AbXGAUV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:21:28 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46856 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758878AbXGAUVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:21:24 -0400
Date: Sun, 1 Jul 2007 22:21:50 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] unexport bio_{,un}map_user
Message-ID: <20070701202150.GN10869@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

bio_{,un}map_user no longer have any modular users.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch has been sent on:
- 24 Mar 2007

--- linux-2.6.21-rc4-mm1/fs/bio.c.old	2007-03-24 11:42:28.000000000 +0100
+++ linux-2.6.21-rc4-mm1/fs/bio.c	2007-03-24 11:42:39.000000000 +0100
@@ -1253,8 +1253,6 @@
 EXPORT_SYMBOL(bio_add_page);
 EXPORT_SYMBOL(bio_add_pc_page);
 EXPORT_SYMBOL(bio_get_nr_vecs);
-EXPORT_SYMBOL(bio_map_user);
-EXPORT_SYMBOL(bio_unmap_user);
 EXPORT_SYMBOL(bio_map_kern);
 EXPORT_SYMBOL(bio_pair_release);
 EXPORT_SYMBOL(bio_split);

