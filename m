Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbYKEN7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbYKEN7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 08:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755625AbYKEN6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 08:58:50 -0500
Received: from verein.lst.de ([213.95.11.210]:52751 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362AbYKEN6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 08:58:49 -0500
Date: Wed, 5 Nov 2008 14:58:46 +0100
From: Christoph Hellwig <hch@lst.de>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] documnt FMODE_ constants
Message-ID: <20081105135846.GC4393@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure all FMODE_ constants are documents, and ensure a coherent
style for the already existing comments.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-11-02 19:48:48.000000000 +0100
+++ linux-2.6/include/linux/fs.h	2008-11-02 19:52:52.000000000 +0100
@@ -63,21 +63,23 @@ extern int dir_notify_enable;
 #define MAY_ACCESS 16
 #define MAY_OPEN 32
 
-#define FMODE_READ ((__force fmode_t)1)
-#define FMODE_WRITE ((__force fmode_t)2)
-
-/* Internal kernel extensions */
-#define FMODE_LSEEK	((__force fmode_t)4)
-#define FMODE_PREAD	((__force fmode_t)8)
-#define FMODE_PWRITE	FMODE_PREAD	/* These go hand in hand */
-
-/* File is being opened for execution. Primary users of this flag are
-   distributed filesystems that can use it to achieve correct ETXTBUSY
-   behavior for cross-node execution/opening_for_writing of files */
-#define FMODE_EXEC	((__force fmode_t)16)
-
-#define FMODE_NDELAY	((__force fmode_t)32)
-#define FMODE_EXCL	((__force fmode_t)64)
+/* file is open for reading */
+#define FMODE_READ		((__force fmode_t)1)
+/* file is open for writing */
+#define FMODE_WRITE		((__force fmode_t)2)
+/* file is seekable */
+#define FMODE_LSEEK		((__force fmode_t)4)
+/* file can be accessed using pread/pwrite */
+#define FMODE_PREAD		((__force fmode_t)8)
+#define FMODE_PWRITE		FMODE_PREAD	/* These go hand in hand */
+/* File is opened for execution with sys_execve / sys_uselib */
+#define FMODE_EXEC		((__force fmode_t)16)
+/* File is opened with O_NDELAY (only set for block devices) */
+#define FMODE_NDELAY		((__force fmode_t)32)
+/* File is opened with O_EXCL (only set for block devices) */
+#define FMODE_EXCL		((__force fmode_t)64)
+/* File is opened using open(.., 3, ..) and is writeable only for ioctls
+   (specialy hack for floppy.c) */
 #define FMODE_WRITE_IOCTL	((__force fmode_t)128)
 
 #define RW_MASK		1
