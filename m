Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab0BYQMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:12:54 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:59124 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932559Ab0BYQMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:12:53 -0500
Date: Thu, 25 Feb 2010 16:13:58 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: phillip.lougher@gmail.com
Subject: [PATCH 1/3] Squashfs: get rid of obsolete variable in struct
 squashfs_sb_info
Message-ID: <4b86a1c6.3H1kbZjem+wRLpNA%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/squashfs_fs_sb.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/squashfs/squashfs_fs_sb.h b/fs/squashfs/squashfs_fs_sb.h
index 7533350..2e77dc5 100644
--- a/fs/squashfs/squashfs_fs_sb.h
+++ b/fs/squashfs/squashfs_fs_sb.h
@@ -61,7 +61,6 @@ struct squashfs_sb_info {
 	int					next_meta_index;
 	__le64					*id_table;
 	__le64					*fragment_index;
-	unsigned int				*fragment_index_2;
 	struct mutex				read_data_mutex;
 	struct mutex				meta_index_mutex;
 	struct meta_index			*meta_index;
-- 
1.6.3.3

