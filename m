Return-Path: <linux-kernel-owner+w=401wt.eu-S934600AbXGZQls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934600AbXGZQls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934661AbXGZQgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:36:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43296 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932942AbXGZQgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:36:04 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] xfs ioctl __user annotations
Cc: linux-kernel@vger.kernel.org, mmarek@suse.cz
Message-Id: <E1IE6Jj-0005RF-RJ@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:35:59 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/xfs/linux-2.6/xfs_ioctl32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_ioctl32.c b/fs/xfs/linux-2.6/xfs_ioctl32.c
index 141cf15..42319d7 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -139,7 +139,7 @@ STATIC int xfs_inumbers_fmt_compat(
 	long count,
 	long *written)
 {
-	compat_xfs_inogrp_t *p32 = ubuffer;
+	compat_xfs_inogrp_t __user *p32 = ubuffer;
 	long i;
 
 	for (i = 0; i < count; i++) {
@@ -444,7 +444,7 @@ xfs_compat_ioctl(
 	case XFS_IOC_FSINUMBERS_32:
 		cmd = _NATIVE_IOC(cmd, struct xfs_fsop_bulkreq);
 		return xfs_ioc_bulkstat_compat(XFS_BHVTOI(VNHEAD(vp))->i_mount,
-				cmd, (void*)arg);
+				cmd, (void __user*)arg);
 	case XFS_IOC_FD_TO_HANDLE_32:
 	case XFS_IOC_PATH_TO_HANDLE_32:
 	case XFS_IOC_PATH_TO_FSHANDLE_32:
-- 
1.5.3.GIT


