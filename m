Return-Path: <linux-kernel-owner+w=401wt.eu-S1752378AbXBDO5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbXBDO5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 09:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbXBDO5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 09:57:45 -0500
Received: from daimi.au.dk ([130.225.16.1]:36499 "EHLO daimi.au.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbXBDO5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 09:57:44 -0500
X-Greylist: delayed 2846 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Feb 2007 09:57:44 EST
Message-ID: <45C5E942.2050700@gmail.com>
Date: Sun, 04 Feb 2007 15:10:10 +0100
From: Ronni Nielsen <theronni@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch] fs/libfs.c >80 columns ine break fix
Content-Type: multipart/mixed;
 boundary="------------010405050108000405020206"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010405050108000405020206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This is a patch agains linus' 2.6 git tree which adds linebreaks to an 
 >80 columns line in fs/libfs.c

Signed-off-by: Ronni Nielsen <theronni@gmail.com>



--------------010405050108000405020206
Content-Type: text/plain;
 name="libfs.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libfs.c.diff"

diff --git a/fs/libfs.c b/fs/libfs.c
index 503898d..ea43af7 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -159,7 +159,10 @@ int dcache_readdir(struct file * filp, void * dirent, filldir_t filldir)
 					continue;
 
 				spin_unlock(&dcache_lock);
-				if (filldir(dirent, next->d_name.name, next->d_name.len, filp->f_pos, next->d_inode->i_ino, dt_type(next->d_inode)) < 0)
+				if (filldir(dirent, next->d_name.name, 
+						next->d_name.len, filp->f_pos, 
+						next->d_inode->i_ino, 
+						dt_type(next->d_inode)) < 0)
 					return 0;
 				spin_lock(&dcache_lock);
 				/* next is still alive */

--------------010405050108000405020206--
