Return-Path: <linux-kernel-owner+w=401wt.eu-S1761332AbYAJPI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761332AbYAJPI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759540AbYAJPBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:01:36 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57055 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758788AbYAJPAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:00:55 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hch@infradead.org, viro@ftp.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 26/29] Unionfs: common header file for user-land utilities and kernel
Date: Thu, 10 Jan 2008 09:59:45 -0500
Message-Id: <1199977205323-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
References: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 include/linux/union_fs.h |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/union_fs.h

diff --git a/include/linux/union_fs.h b/include/linux/union_fs.h
new file mode 100644
index 0000000..9d601d2
--- /dev/null
+++ b/include/linux/union_fs.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
+ * Copyright (c) 2003-2007 Stony Brook University
+ * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _LINUX_UNION_FS_H
+#define _LINUX_UNION_FS_H
+
+#define UNIONFS_VERSION  "2.2-mm"
+
+/*
+ * DEFINITIONS FOR USER AND KERNEL CODE:
+ */
+# define UNIONFS_IOCTL_INCGEN		_IOR(0x15, 11, int)
+# define UNIONFS_IOCTL_QUERYFILE	_IOR(0x15, 15, int)
+
+#endif /* _LINUX_UNIONFS_H */
+
-- 
1.5.2.2

