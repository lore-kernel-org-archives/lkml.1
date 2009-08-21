Return-Path: <linux-kernel-owner+w=401wt.eu-S932879AbZHUR1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879AbZHUR1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932551AbZHUR1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:27:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50223 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932735AbZHURYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:24:10 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: hch@lst.de, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
       linux-nfs@vger.kernel.org, Neil Brown <neilb@suse.de>,
       "J. Bruce Fields" <bfields@fieldses.org>
Subject: [PATCH 15/17] nfs: Remove reference to generic_osync_inode from a comment
Date: Fri, 21 Aug 2009 19:24:05 +0200
Message-Id: <1250875447-15622-16-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1250875447-15622-1-git-send-email-jack@suse.cz>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

generic_file_direct_write() no longer calls generic_osync_inode() so remove the
comment.

CC: linux-nfs@vger.kernel.org
CC: Neil Brown <neilb@suse.de>
CC: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/nfs/direct.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 489fc01..fd5fcc9 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -934,9 +934,6 @@ out:
  * back into its cache.  We let the server do generic write
  * parameter checking and report problems.
  *
- * We also avoid an unnecessary invocation of generic_osync_inode(),
- * as it is fairly meaningless to sync the metadata of an NFS file.
- *
  * We eliminate local atime updates, see direct read above.
  *
  * We avoid unnecessary page cache invalidations for normal cached
-- 
1.6.0.2

