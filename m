Return-Path: <linux-kernel-owner+w=401wt.eu-S1764495AbYEPPCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764495AbYEPPCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757841AbYEPOoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:44:34 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49286 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbYEPOmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:21 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 6/67] aufs main header file
Date: Fri, 16 May 2008 23:32:20 +0900
Message-Id: <1210948401415-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484013436-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs main header file

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/aufs.h |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/aufs.h b/fs/aufs/aufs.h
new file mode 100644
index 0000000..915bde0
--- /dev/null
+++ b/fs/aufs/aufs.h
@@ -0,0 +1,56 @@
+/*
+ * Copyright (C) 2005-2008 Junjiro Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+/*
+ * main header files
+ *
+ * $Id: aufs.h,v 1.2 2008/04/21 01:31:49 sfjro Exp $
+ */
+
+#ifndef __AUFS_H__
+#define __AUFS_H__
+
+#ifdef __KERNEL__
+
+#include <linux/version.h>
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 25)
+#error you got wrong version
+#endif
+
+#include "debug.h"
+
+#include "branch.h"
+#include "cpup.h"
+#include "dcsub.h"
+#include "dentry.h"
+#include "dir.h"
+#include "file.h"
+#include "hinode.h"
+#include "inode.h"
+#include "misc.h"
+#include "module.h"
+#include "opts.h"
+#include "super.h"
+#include "sysaufs.h"
+#include "vfsub.h"
+#include "whout.h"
+#include "wkq.h"
+//#include "xattr.h"
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_H__ */
-- 
1.4.4.4

