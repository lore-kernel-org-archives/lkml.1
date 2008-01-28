Return-Path: <linux-kernel-owner+w=401wt.eu-S1760742AbYA1MSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760742AbYA1MSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 07:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYA1MS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 07:18:27 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54565 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbYA1MS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 07:18:26 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch] use __u32 in linux/reiserfs_fs.h
Date: Mon, 28 Jan 2008 07:18:23 -0500
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801280718.23689.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since this header is exported to userspace and all the other types in the
header have been scrubbed, this brings the last straggler in line.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index 422eab4..8e7eff2 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -287,7 +287,7 @@
 
 /* Don't trust REISERFS_SB(sb)->s_bmap_nr, it's a u16
  * which overflows on large file systems. */
-static inline u32 reiserfs_bmap_count(struct super_block *sb)
+static inline __u32 reiserfs_bmap_count(struct super_block *sb)
 {
 	return (SB_BLOCK_COUNT(sb) - 1) / (sb->s_blocksize * 8) + 1;
 }
