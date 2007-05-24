Return-Path: <linux-kernel-owner+w=401wt.eu-S1761588AbXEXAgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761588AbXEXAgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758025AbXEXAgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:36:22 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40210 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757606AbXEXAgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:36:20 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 01/21] Unionfs: Tiny documentation fixups
Date: Wed, 23 May 2007 20:35:51 -0400
Message-Id: <11799669711151-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
References: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 Documentation/filesystems/unionfs/usage.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/unionfs/usage.txt b/Documentation/filesystems/unionfs/usage.txt
index 13fbcea..1c7554b 100644
--- a/Documentation/filesystems/unionfs/usage.txt
+++ b/Documentation/filesystems/unionfs/usage.txt
@@ -81,10 +81,10 @@ CACHE CONSISTENCY
 If you modify any file on any of the lower branches directly, while there is
 a Unionfs 2.0 mounted above any of those branches, you should tell Unionfs
 to purge its caches and re-get the objects.  To do that, you have to
-incremenet the generation number of the superblock using the following
+increment the generation number of the superblock using the following
 command:
 
-# mount -t unionfs -o remount,remount,incgen none MOUNTPOINT
+# mount -t unionfs -o remount,incgen none MOUNTPOINT
 
 
 For more information, see <http://unionfs.filesystems.org/>.
-- 
1.5.2.rc1.165.gaf9b

