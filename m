Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbYA0CTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbYA0CTK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 21:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbYA0CRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 21:17:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54469 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789AbYA0CRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 21:17:14 -0500
From: Andi Kleen <ak@suse.de>
References: <20080127317.043953000@suse.de>
In-Reply-To: <20080127317.043953000@suse.de>
To: sct@redhat.com, adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [7/18] BKL-removal: Remove incorrect comments refering to BKL from ext4
Message-Id: <20080127021713.9216B14D2E@wotan.suse.de>
Date: Sun, 27 Jan 2008 03:17:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


BKL is not hold in any of those

Cc: sct@redhat.com
Cc: adilger@clusterfs.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/ext4/dir.c   |    2 +-
 fs/ext4/inode.c |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

Index: linux/fs/ext4/dir.c
===================================================================
--- linux.orig/fs/ext4/dir.c
+++ linux/fs/ext4/dir.c
@@ -46,7 +46,7 @@ const struct file_operations ext4_dir_op
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext4_compat_ioctl,
 #endif
-	.fsync		= ext4_sync_file,	/* BKL held */
+	.fsync		= ext4_sync_file,
 	.release	= ext4_release_dir,
 };
 
Index: linux/fs/ext4/inode.c
===================================================================
--- linux.orig/fs/ext4/inode.c
+++ linux/fs/ext4/inode.c
@@ -778,7 +778,6 @@ err_out:
  *
  * `handle' can be NULL if create == 0.
  *
- * The BKL may not be held on entry here.  Be sure to take it early.
  * return > 0, # of blocks mapped or allocated.
  * return = 0, if plain lookup failed.
  * return < 0, error case.
