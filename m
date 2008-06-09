Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbYFIWbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbYFIWbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762005AbYFIW2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:28:24 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47352 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760013AbYFIW2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:28:23 -0400
Date: Tue, 10 Jun 2008 01:27:29 +0300
From: Adrian Bunk <bunk@kernel.org>
To: shaggy@austin.ibm.com
Cc: jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] jfs: remove DIRENTSIZ
Message-ID: <20080609222729.GA1987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After fat gets fixed the unused DIRENTSIZ macro was the last user of
struct dirent we should get rid of since the kernel and userspace 
versions differed.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
89432c9b7ff2cd2e29fc5f2edde120dc38a89f46 diff --git a/fs/jfs/jfs_dtree.h b/fs/jfs/jfs_dtree.h
index cdac2d5..2545bb3 100644
--- a/fs/jfs/jfs_dtree.h
+++ b/fs/jfs/jfs_dtree.h
@@ -243,9 +243,6 @@ typedef union {
 #define JFS_REMOVE 3
 #define JFS_RENAME 4
 
-#define DIRENTSIZ(namlen) \
-    ( (sizeof(struct dirent) - 2*(JFS_NAME_MAX+1) + 2*((namlen)+1) + 3) &~ 3 )
-
 /*
  * Maximum file offset for directories.
  */

