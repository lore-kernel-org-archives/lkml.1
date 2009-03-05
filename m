Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbZCENfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbZCENfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZCENfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:35:34 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:40913 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbZCENfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:35:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=qkQfZQFNODQTtPGGaKmBwmpwWcdOw86VFoWMbv0d879n2jH5mrSw2GqOkfbmG82Owz
         ra7uG3cyiF/oNewYK9yknr/hYFFzg5DEKgERiA6F275MBPBN8/ZTPXX1QcYUt3DDAMOF
         4AsKQL5hA22OmMp8VvQz+xDQQjXucqilvMyDU=
Date: Thu, 5 Mar 2009 16:42:19 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, alan@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] devpts: remove graffiti
Message-ID: <20090305134219.GA2202@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very annoying when working with containters.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/devpts/inode.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -198,9 +198,6 @@ static int mknod_ptmx(struct super_block *sb)
 
 	fsi->ptmx_dentry = dentry;
 	rc = 0;
-
-	printk(KERN_DEBUG "Created ptmx node in devpts ino %lu\n",
-			inode->i_ino);
 out:
 	mutex_unlock(&root->d_inode->i_mutex);
 	return rc;
@@ -369,8 +366,6 @@ static int new_pts_mount(struct file_system_type *fs_type, int flags,
 	struct pts_fs_info *fsi;
 	struct pts_mount_opts *opts;
 
-	printk(KERN_NOTICE "devpts: newinstance mount\n");
-
 	err = get_sb_nodev(fs_type, flags, data, devpts_fill_super, mnt);
 	if (err)
 		return err;
