Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbZEUUB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbZEUUB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 16:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbZEUUBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 16:01:09 -0400
Received: from thunk.org ([69.25.196.29]:39203 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbZEUUBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 16:01:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 4/5] fs: Rearrange inode structure elements to avoid waste due to padding
Date: Thu, 21 May 2009 16:01:02 -0400
Message-Id: <1242936063-31689-5-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.1.1.g75fc.dirty
In-Reply-To: <1242936063-31689-4-git-send-email-tytso@mit.edu>
References: <1242936063-31689-1-git-send-email-tytso@mit.edu>
 <1242936063-31689-2-git-send-email-tytso@mit.edu>
 <1242936063-31689-3-git-send-email-tytso@mit.edu>
 <1242936063-31689-4-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org
---
 include/linux/fs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7c73c59..88bd16a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -729,8 +729,8 @@ struct inode {
 	struct timespec		i_atime;
 	struct timespec		i_mtime;
 	struct timespec		i_ctime;
-	unsigned int		i_blkbits;
 	blkcnt_t		i_blocks;
+	unsigned int		i_blkbits;
 	unsigned short          i_bytes;
 	umode_t			i_mode;
 	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */
-- 
1.6.3.1.1.g75fc.dirty

