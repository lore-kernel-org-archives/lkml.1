Return-Path: <linux-kernel-owner+w=401wt.eu-S1760809AbYCZSFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760809AbYCZSFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758333AbYCZSF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:05:28 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:3167 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758149AbYCZSF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:05:26 -0400
Subject: [PATCH] fs/xfs - Use #include "xfs.h" not <xfs.h>
From: Joe Perches <joe@perches.com>
To: xfs-masters <xfs-masters@oss.sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 11:05:02 -0700
Message-Id: <1206554702.4845.236.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to use angle bracket includes

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/xfs/linux-2.6/xfs_linux.h |   46 +++++++++++++++++++++---------------------
 fs/xfs/support/debug.c       |    2 +-
 fs/xfs/support/ktrace.c      |    2 +-
 fs/xfs/support/uuid.c        |    2 +-
 fs/xfs/xfs.h                 |    2 +-
 5 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_linux.h b/fs/xfs/linux-2.6/xfs_linux.h
index 3ca39c4..2d6cd84 100644
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ b/fs/xfs/linux-2.6/xfs_linux.h
@@ -38,19 +38,19 @@
 # define XFS_BIG_INUMS	0
 #endif
 
-#include <xfs_types.h>
-#include <xfs_arch.h>
+#include "xfs_types.h"
+#include "xfs_arch.h"
 
-#include <kmem.h>
-#include <mrlock.h>
-#include <sv.h>
-#include <mutex.h>
-#include <sema.h>
-#include <time.h>
+#include "kmem.h"
+#include "mrlock.h"
+#include "sv.h"
+#include "mutex.h"
+#include "sema.h"
+#include "time.h"
 
-#include <support/ktrace.h>
-#include <support/debug.h>
-#include <support/uuid.h>
+#include "support/ktrace.h"
+#include "support/debug.h"
+#include "support/uuid.h"
 
 #include <linux/mm.h>
 #include <linux/kernel.h>
@@ -83,18 +83,18 @@
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
-#include <xfs_vfs.h>
-#include <xfs_cred.h>
-#include <xfs_vnode.h>
-#include <xfs_stats.h>
-#include <xfs_sysctl.h>
-#include <xfs_iops.h>
-#include <xfs_aops.h>
-#include <xfs_super.h>
-#include <xfs_globals.h>
-#include <xfs_fs_subr.h>
-#include <xfs_lrw.h>
-#include <xfs_buf.h>
+#include "xfs_vfs.h"
+#include "xfs_cred.h"
+#include "xfs_vnode.h"
+#include "xfs_stats.h"
+#include "xfs_sysctl.h"
+#include "xfs_iops.h"
+#include "xfs_aops.h"
+#include "xfs_super.h"
+#include "xfs_globals.h"
+#include "xfs_fs_subr.h"
+#include "xfs_lrw.h"
+#include "xfs_buf.h"
 
 /*
  * Feature macros (disable/enable)
diff --git a/fs/xfs/support/debug.c b/fs/xfs/support/debug.c
index c27abef..4253b79 100644
--- a/fs/xfs/support/debug.c
+++ b/fs/xfs/support/debug.c
@@ -15,7 +15,7 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-#include <xfs.h>
+#include "xfs.h"
 #include "debug.h"
 
 static char		message[1024];	/* keep it off the stack */
diff --git a/fs/xfs/support/ktrace.c b/fs/xfs/support/ktrace.c
index 129067c..4f4789d 100644
--- a/fs/xfs/support/ktrace.c
+++ b/fs/xfs/support/ktrace.c
@@ -15,7 +15,7 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-#include <xfs.h>
+#include "xfs.h"
 
 static kmem_zone_t *ktrace_hdr_zone;
 static kmem_zone_t *ktrace_ent_zone;
diff --git a/fs/xfs/support/uuid.c b/fs/xfs/support/uuid.c
index 493a6ec..7547e12 100644
--- a/fs/xfs/support/uuid.c
+++ b/fs/xfs/support/uuid.c
@@ -15,7 +15,7 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-#include <xfs.h>
+#include "xfs.h"
 
 static mutex_t	uuid_monitor;
 static int	uuid_table_size;
diff --git a/fs/xfs/xfs.h b/fs/xfs/xfs.h
index 540e4c9..ec24787 100644
--- a/fs/xfs/xfs.h
+++ b/fs/xfs/xfs.h
@@ -41,5 +41,5 @@
 #define XFS_FILESTREAMS_TRACE 1
 #endif
 
-#include <linux-2.6/xfs_linux.h>
+#include "linux-2.6/xfs_linux.h"
 #endif	/* __XFS_H__ */


