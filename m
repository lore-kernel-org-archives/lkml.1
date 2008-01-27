Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbYA0CSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbYA0CSp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 21:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756232AbYA0CRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 21:17:18 -0500
Received: from ns.suse.de ([195.135.220.2]:54336 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbYA0CRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 21:17:11 -0500
From: Andi Kleen <ak@suse.de>
References: <20080127317.043953000@suse.de>
In-Reply-To: <20080127317.043953000@suse.de>
To: sct@redhat.com, adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [4/18] ext3: Remove incorrect BKL comment
Message-Id: <20080127021710.6615B14D2E@wotan.suse.de>
Date: Sun, 27 Jan 2008 03:17:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is no BKL held on entry in ->fsync nor in the low level ext3_sync_file.

Cc: sct@redhat.com
Cc: adilger@clusterfs.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/ext3/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/fs/ext3/dir.c
===================================================================
--- linux.orig/fs/ext3/dir.c
+++ linux/fs/ext3/dir.c
@@ -46,7 +46,7 @@ const struct file_operations ext3_dir_op
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
 #endif
-	.fsync		= ext3_sync_file,	/* BKL held */
+	.fsync		= ext3_sync_file,
 	.release	= ext3_release_dir,
 };
 
