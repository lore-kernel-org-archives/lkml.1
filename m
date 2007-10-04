Return-Path: <linux-kernel-owner+w=401wt.eu-S1757202AbXJDJX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbXJDJX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759504AbXJDJRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759268AbXJDJRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:46 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Denis Cheng <crquan@gmail.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 17/51] [GFS2] unneeded typecast
Date: Thu,  4 Oct 2007 09:49:10 +0100
Message-Id: <11914878214113-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878191964-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
 <11914878063121-git-send-email-swhiteho@redhat.com>
 <11914878081562-git-send-email-swhiteho@redhat.com>
 <11914878102813-git-send-email-swhiteho@redhat.com>
 <1191487812928-git-send-email-swhiteho@redhat.com>
 <11914878141625-git-send-email-swhiteho@redhat.com>
 <1191487815172-git-send-email-swhiteho@redhat.com>
 <11914878173677-git-send-email-swhiteho@redhat.com>
 <11914878191964-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>

sb->s_fs_info is a void pointer, thus the type cast is not needed.

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 32b2859..25cfab9 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -849,7 +849,7 @@ static int gfs2_get_sb_meta(struct file_system_type *fs_type, int flags,
 		error = -ENOENT;
 		goto error;
 	}
-	sdp = (struct gfs2_sbd*) sb->s_fs_info;
+	sdp = sb->s_fs_info;
 	if (sdp->sd_vfs_meta) {
 		printk(KERN_WARNING "GFS2: gfs2meta mount already exists\n");
 		error = -EBUSY;
-- 
1.5.1.2

