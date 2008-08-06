Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbYHFVoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbYHFVoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYHFVoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:44:09 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:60595 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbYHFVoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:44:08 -0400
Date: Thu, 7 Aug 2008 00:10:09 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] fs/partitions/acorn.c: remove dead code
Message-ID: <20080806211008.GA1702@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I missed this when I did the arm26 removal.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 23 Apr 2008
- 14 Apr 2008
- 31 Mar 2008
- 1 Mar 2008

 fs/partitions/acorn.c |   10 ----------
 1 file changed, 10 deletions(-)

f7dc697bb2d04227b2f41a9d56f626fbd65c3d9d foobar
diff --git a/fs/partitions/acorn.c b/fs/partitions/acorn.c
index 3d3e166..a97b477 100644
--- a/fs/partitions/acorn.c
+++ b/fs/partitions/acorn.c
@@ -275,16 +275,6 @@ adfspart_check_ADFS(struct parsed_partitions *state, struct block_device *bdev)
 	id = data[0x1fc] & 15;
 	put_dev_sector(sect);
 
-#ifdef CONFIG_BLK_DEV_MFM
-	if (MAJOR(bdev->bd_dev) == MFM_ACORN_MAJOR) {
-		extern void xd_set_geometry(struct block_device *,
-			unsigned char, unsigned char, unsigned int);
-		xd_set_geometry(bdev, dr->secspertrack, heads, 1);
-		invalidate_bh_lrus();
-		truncate_inode_pages(bdev->bd_inode->i_mapping, 0);
-	}
-#endif
-
 	/*
 	 * Work out start of non-adfs partition.
 	 */



