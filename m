Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbXL1Utz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbXL1Utz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbXL1UoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:44:19 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37161 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbXL1Unx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:43:53 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 26/30] Unionfs: initialize namelist variable in rename
Date: Fri, 28 Dec 2007 15:43:00 -0500
Message-Id: <11988745973488-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/rename.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index 1019d47..9306a2b 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -462,7 +462,7 @@ int unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		}
 
 		if (S_ISDIR(new_dentry->d_inode->i_mode)) {
-			struct unionfs_dir_state *namelist;
+			struct unionfs_dir_state *namelist = NULL;
 			/* check if this unionfs directory is empty or not */
 			err = check_empty(new_dentry, &namelist);
 			if (err)
-- 
1.5.2.2

