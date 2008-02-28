Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYB1Gqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYB1Gqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 01:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756560AbYB1Gpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 01:45:46 -0500
Received: from host106.paramount.wayport.net ([65.249.24.106]:52727 "EHLO
	honeydew.int.wil.cx" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756358AbYB1Gpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 01:45:44 -0500
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 06/12] fs: Remove unnecessary inclusions of asm/semaphore.h
Date: Thu, 28 Feb 2008 01:33:55 -0500
Message-Id: <1204180441-8540-6-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204180441-8540-5-git-send-email-matthew@wil.cx>
References: <20080227003605.GC5715@parisc-linux.org>
 <1204180441-8540-1-git-send-email-matthew@wil.cx>
 <1204180441-8540-2-git-send-email-matthew@wil.cx>
 <1204180441-8540-3-git-send-email-matthew@wil.cx>
 <1204180441-8540-4-git-send-email-matthew@wil.cx>
 <1204180441-8540-5-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files use any of the functionality promised by
asm/semaphore.h.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 fs/9p/fid.c           |    1 -
 fs/cramfs/inode.c     |    1 -
 fs/dlm/dlm_internal.h |    1 -
 fs/locks.c            |    1 -
 fs/reiserfs/xattr.c   |    1 -
 5 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index dfebdbe..3031e32 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -26,7 +26,6 @@
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/idr.h>
-#include <asm/semaphore.h>
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 
diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 350680f..0c3b618 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -23,7 +23,6 @@
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
 #include <linux/mutex.h>
-#include <asm/semaphore.h>
 
 #include <asm/uaccess.h>
 
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index d30ea8b..7a8824f 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -37,7 +37,6 @@
 #include <linux/jhash.h>
 #include <linux/miscdevice.h>
 #include <linux/mutex.h>
-#include <asm/semaphore.h>
 #include <asm/uaccess.h>
 
 #include <linux/dlm.h>
diff --git a/fs/locks.c b/fs/locks.c
index f36f0e6..1100df6 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -127,7 +127,6 @@
 #include <linux/rcupdate.h>
 #include <linux/pid_namespace.h>
 
-#include <asm/semaphore.h>
 #include <asm/uaccess.h>
 
 #define IS_POSIX(fl)	(fl->fl_flags & FL_POSIX)
diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index eba037b..736bc47 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -44,7 +44,6 @@
 #include <net/checksum.h>
 #include <linux/smp_lock.h>
 #include <linux/stat.h>
-#include <asm/semaphore.h>
 
 #define FL_READONLY 128
 #define FL_DIR_SEM_HELD 256
-- 
1.5.4.1

