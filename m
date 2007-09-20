Return-Path: <linux-kernel-owner+w=401wt.eu-S1761921AbXITIeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761921AbXITIeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758467AbXITIbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:31:55 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:31752 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990AbXITIbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:31:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=ifTTXOgF31rKRzPFY8RkWoSKcQ+nBzUyCZ52Jx0cLpOSmu1NBfCGba3vsGxdGTVFCnj+Vt5Tj6F1Scmz9qmGGJ4vZSOlJWIXwYuOipmH6hAz/Cazj7ekjncF7DkrpnbTxGABzlDEjXEOjScGQ1SWUkYk86cLZ2CYPw/b+LcwvwA=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 8/8] sysfs: add copyrights
In-Reply-To: <11902770971822-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:31:38 +0900
Message-Id: <11902770982175-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sysfs has gone through considerable amount of reimplementation.  Add
copyrights.  Any objections?  :-)

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/bin.c                |    8 +++++++-
 fs/sysfs/dir.c                |   10 +++++++++-
 fs/sysfs/file.c               |   10 +++++++++-
 fs/sysfs/inode.c              |    8 ++++++--
 fs/sysfs/kobject.c            |    2 ++
 fs/sysfs/mount.c              |   10 +++++++++-
 fs/sysfs/symlink.c            |   10 +++++++++-
 fs/sysfs/sysfs.h              |   10 ++++++++++
 include/linux/sysfs-kobject.h |    2 ++
 include/linux/sysfs.h         |    4 ++++
 10 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 1f705d2..ae6986d 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -1,9 +1,15 @@
 /*
- * bin.c - binary file operations for sysfs.
+ * fs/sysfs/bin.c - sysfs binary file implementation
  *
  * Copyright (c) 2003 Patrick Mochel
  * Copyright (c) 2003 Matthew Wilcox
  * Copyright (c) 2004 Silicon Graphics, Inc.
+ * Copyright (c) 2007 SUSE Linux Products GmbH
+ * Copyright (c) 2007 Tejun Heo <teheo@suse.de>
+ *
+ * This file is released under the GPLv2.
+ *
+ * Please see Documentation/filesystems/sysfs.txt for more information.
  */
 
 #undef DEBUG
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index f18da1b..a8571f4 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -1,5 +1,13 @@
 /*
- * dir.c - Operations for sysfs directories.
+ * fs/sysfs/dir.c - sysfs core and dir operation implementation
+ *
+ * Copyright (c) 2001-3 Patrick Mochel
+ * Copyright (c) 2007 SUSE Linux Products GmbH
+ * Copyright (c) 2007 Tejun Heo <teheo@suse.de>
+ *
+ * This file is released under the GPLv2.
+ *
+ * Please see Documentation/filesystems/sysfs.txt for more information.
  */
 
 #undef DEBUG
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 3412732..68ec732 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -1,5 +1,13 @@
 /*
- * file.c - operations for regular (text) files.
+ * fs/sysfs/file.c - sysfs regular (text) file implementation
+ *
+ * Copyright (c) 2001-3 Patrick Mochel
+ * Copyright (c) 2007 SUSE Linux Products GmbH
+ * Copyright (c) 2007 Tejun Heo <teheo@suse.de>
+ *
+ * This file is released under the GPLv2.
+ *
+ * Please see Documentation/filesystems/sysfs.txt for more information.
  */
 
 #include <linux/module.h>
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index bd61cca..6834a11 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -1,7 +1,11 @@
 /*
- * inode.c - basic inode and dentry operations.
+ * fs/sysfs/inode.c - basic sysfs inode and dentry operations
  *
- * sysfs is Copyright (c) 2001-3 Patrick Mochel
+ * Copyright (c) 2001-3 Patrick Mochel
+ * Copyright (c) 2007 SUSE Linux Products GmbH
+ * Copyright (c) 2007 Tejun Heo <teheo@suse.de>
+ *
+ * This file is released under the GPLv2.
  *
  * Please see Documentation/filesystems/sysfs.txt for more information.
  */
diff --git a/fs/sysfs/kobject.c b/fs/sysfs/kobject.c
index 7ea9186..c0bc77d 100644
--- a/fs/sysfs/kobject.c
+++ b/fs/sysfs/kobject.c
@@ -3,6 +3,8 @@
  *
  * Copyright (c) 2001,2002 Patrick Mochel
  * Copyright (c) 2004 Silicon Graphics, Inc.
+ * Copyright (c) 2007 SUSE Linux Products GmbH
+ * Copyright (c) 2007 Tejun Heo <teheo@suse.de>
  *
  * This is compatibility interface which wraps the primary interface
  * defined in linux/sysfs.h to remain compatible with the original
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index d61eb08..642988f 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -1,5 +1,13 @@
 /*
- * mount.c - operations for initializing and mounting sysfs.
+ * fs/sysfs/symlink.c - operations for initializing and mounting sysfs
+ *
+ * Copyright (c) 2001-3 Patrick Mochel
+ * Copyright (c) 2007 SUSE Linux Products GmbH
+ * Copyright (c) 2007 Tejun Heo <teheo@suse.de>
+ *
+ * This file is released under the GPLv2.
+ *
+ * Please see Documentation/filesystems/sysfs.txt for more information.
  */
 
 #define DEBUG 
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 7e0fd89..ed2550c 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -1,5 +1,13 @@
 /*
- * symlink.c - operations for sysfs symlinks.
+ * fs/sysfs/symlink.c - sysfs symlink implementation
+ *
+ * Copyright (c) 2001-3 Patrick Mochel
+ * Copyright (c) 2007 SUSE Linux Products GmbH
+ * Copyright (c) 2007 Tejun Heo <teheo@suse.de>
+ *
+ * This file is released under the GPLv2.
+ *
+ * Please see Documentation/filesystems/sysfs.txt for more information.
  */
 
 #include <linux/fs.h>
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index ec0b308..a92a95d 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -1,3 +1,13 @@
+/*
+ * fs/sysfs/sysfs.h - sysfs internal header file
+ *
+ * Copyright (c) 2001-3 Patrick Mochel
+ * Copyright (c) 2007 SUSE Linux Products GmbH
+ * Copyright (c) 2007 Tejun Heo <teheo@suse.de>
+ *
+ * This file is released under the GPLv2.
+ */
+
 struct sysfs_open_dirent;
 
 /* type-specific structures for sysfs_dirent->s_* union members */
diff --git a/include/linux/sysfs-kobject.h b/include/linux/sysfs-kobject.h
index 4c821c2..dbbad99 100644
--- a/include/linux/sysfs-kobject.h
+++ b/include/linux/sysfs-kobject.h
@@ -3,6 +3,8 @@
  *
  * Copyright (c) 2001,2002 Patrick Mochel
  * Copyright (c) 2004 Silicon Graphics, Inc.
+ * Copyright (c) 2007 SUSE Linux Products GmbH
+ * Copyright (c) 2007 Tejun Heo <teheo@suse.de>
  *
  * This is compatibility interface which wraps the primary interface
  * defined in linux/sysfs.h to remain compatible with the original
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index a8dfc6b..22cdbf4 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -1,6 +1,10 @@
 /*
  * sysfs.h - definitions for the device driver filesystem
  *
+ * Copyright (c) 2001-3 Patrick Mochel
+ * Copyright (c) 2007 SUSE Linux Products GmbH
+ * Copyright (c) 2007 Tejun Heo <teheo@suse.de>
+ *
  * Primary sysfs interface based on sysfs_dirent
  *
  * If you're using sysfs directly instead of via driver model, please
-- 
1.5.0.3


