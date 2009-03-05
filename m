Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbZCETSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbZCETSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757626AbZCETSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:18:22 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:33492 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919AbZCETSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:18:20 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH v2 13/15] NULL noise: fs/reiserfs/inode.c
Date: Thu, 05 Mar 2009 20:18:05 +0100
Message-ID: <20090305191745.30062.89094.stgit@f10box.hanneseder.net>
In-Reply-To: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: trivial@kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       reiserfs-devel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  fs/reiserfs/inode.c:2555:19: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
v2: other subject, as suggested by Al Viro

 fs/reiserfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 823227a..e69d63a 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -2552,7 +2552,7 @@ static int reiserfs_write_begin(struct file *file,
 	int old_ref = 0;
 
  	inode = mapping->host;
-	*fsdata = 0;
+	*fsdata = NULL;
  	if (flags & AOP_FLAG_CONT_EXPAND &&
  	    (pos & (inode->i_sb->s_blocksize - 1)) == 0) {
  		pos ++;

