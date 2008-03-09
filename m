Return-Path: <linux-kernel-owner+w=401wt.eu-S1755779AbYCIX7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbYCIX7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 19:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYCIX7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 19:59:30 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4379 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbYCIX73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 19:59:29 -0400
Subject: [PATCH] include/linux/ext4_fs.h - remove duplicate include
From: Joe Perches <joe@perches.com>
To: "Ted Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@clusterfs.com>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       Eric Sandeen <sandeen@redhat.com>, Mingming Cao <cmm@us.ibm.com>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 09 Mar 2008 16:55:04 -0700
Message-Id: <1205106904.656.98.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

 include/linux/ext4_fs.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 2500325..5c1677a 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -19,7 +19,6 @@
 #include <linux/types.h>
 #include <linux/blkdev.h>
 #include <linux/magic.h>
-
 #include <linux/ext4_fs_i.h>
 
 /*
@@ -176,7 +175,6 @@ struct ext4_group_desc
 #define EXT4_BG_INODE_ZEROED	0x0004 /* On-disk itable initialized to zero */
 
 #ifdef __KERNEL__
-#include <linux/ext4_fs_i.h>
 #include <linux/ext4_fs_sb.h>
 #endif
 /*


