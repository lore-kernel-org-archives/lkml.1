Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbZANWk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbZANWk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbZANWks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:40:48 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:44057 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbZANWkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:40:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=en/3GZ2VNXi5WzO3/c7HG4gVX/G+qJXe7CpP950MhYQw4hFLizHZKD2efWlGyUD9SU
         VMy9HWzEa4VFtOqka6mOAA7hDr1jXpJppqQUNIYn31Eer20+RO1m7gas+kH843snZcYr
         ZCvv3mxAZ5SO/ftzerjDsCY4mYVvSocLPsE50=
Date: Thu, 15 Jan 2009 06:40:46 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: chris.mason@oracle.com
Subject: Btrfs: removed unused #include <version.h>'s
Cc: linux-kernel@vger.kernel.org
Message-Id: <20090115063623.1F0D.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unused #include <version.h>'s in files below,
  fs/btrfs/async-thread.c
  fs/btrfs/compression.c
  fs/btrfs/disk-io.c
  fs/btrfs/extent-tree.c
  fs/btrfs/extent_io.c
  fs/btrfs/extent_map.c
  fs/btrfs/file.c
  fs/btrfs/inode.c
  fs/btrfs/ioctl.c
  fs/btrfs/super.c
  fs/btrfs/volumes.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 8e2fec0..d5f4e94 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -16,7 +16,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#include <linux/version.h>
 #include <linux/kthread.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index ee848d8..ab07627 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -32,7 +32,6 @@
 #include <linux/swap.h>
 #include <linux/writeback.h>
 #include <linux/bit_spinlock.h>
-#include <linux/version.h>
 #include <linux/pagevec.h>
 #include "compat.h"
 #include "ctree.h"
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 81a3138..37e12f6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -16,7 +16,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#include <linux/version.h>
 #include <linux/fs.h>
 #include <linux/blkdev.h>
 #include <linux/scatterlist.h>
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 293da65..cdc961e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -19,7 +19,6 @@
 #include <linux/pagemap.h>
 #include <linux/writeback.h>
 #include <linux/blkdev.h>
-#include <linux/version.h>
 #include "compat.h"
 #include "hash.h"
 #include "crc32c.h"
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e086d40..c9446d4 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -9,7 +9,6 @@
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
 #include <linux/swap.h>
-#include <linux/version.h>
 #include <linux/writeback.h>
 #include <linux/pagevec.h>
 #include "extent_io.h"
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 4a83e33..50da69d 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -3,7 +3,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <linux/version.h>
 #include <linux/hardirq.h>
 #include "extent_map.h"
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 9026833..fbcbf43 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -29,7 +29,6 @@
 #include <linux/writeback.h>
 #include <linux/statfs.h>
 #include <linux/compat.h>
-#include <linux/version.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8adfe05..44dbd55 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -34,7 +34,6 @@
 #include <linux/statfs.h>
 #include <linux/compat.h>
 #include <linux/bit_spinlock.h>
-#include <linux/version.h>
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
 #include <linux/falloc.h>
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c2aa33e..988fdc8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -38,7 +38,6 @@
 #include <linux/compat.h>
 #include <linux/bit_spinlock.h>
 #include <linux/security.h>
-#include <linux/version.h>
 #include <linux/xattr.h>
 #include <linux/vmalloc.h>
 #include "compat.h"
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0a14b49..25d8f65 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -37,7 +37,6 @@
 #include <linux/ctype.h>
 #include <linux/namei.h>
 #include <linux/miscdevice.h>
-#include <linux/version.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b187b53..b6955a1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -20,7 +20,6 @@
 #include <linux/buffer_head.h>
 #include <linux/blkdev.h>
 #include <linux/random.h>
-#include <linux/version.h>
 #include <asm/div64.h>
 #include "compat.h"
 #include "ctree.h"

