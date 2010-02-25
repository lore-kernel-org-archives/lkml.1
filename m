Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab0BYQNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:13:51 -0500
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:55402 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932782Ab0BYQNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:13:50 -0500
Date: Thu, 25 Feb 2010 16:14:54 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: phillip.lougher@gmail.com
Subject: [PATCH 2/3] Squashfs: get rid of obsolete definition in header
 file
Message-ID: <4b86a1fe.tXQ8/ElGI6AXgLb2%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/squashfs_fs.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/squashfs/squashfs_fs.h b/fs/squashfs/squashfs_fs.h
index 36e1604..7902424 100644
--- a/fs/squashfs/squashfs_fs.h
+++ b/fs/squashfs/squashfs_fs.h
@@ -183,8 +183,6 @@
 #define SQUASHFS_MAX_FILE_SIZE		(1LL << \
 					(SQUASHFS_MAX_FILE_SIZE_LOG - 2))
 
-#define SQUASHFS_MARKER_BYTE		0xff
-
 /* meta index cache */
 #define SQUASHFS_META_INDEXES	(SQUASHFS_METADATA_SIZE / sizeof(unsigned int))
 #define SQUASHFS_META_ENTRIES	127
-- 
1.6.3.3

