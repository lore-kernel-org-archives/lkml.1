Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbYCFBSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbYCFBSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 20:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761252AbYCFBPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 20:15:14 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:20187 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758894AbYCFBPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 20:15:05 -0500
From: Joel Becker <joel.becker@oracle.com>
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mark.fasheh@oracle.com, teigland@redhat.com
Subject: [PATCH 01/10] ocfs2: Add the user stack module.
Date: Wed,  5 Mar 2008 17:13:49 -0800
Message-Id: <1204766038-31721-2-git-send-email-joel.becker@oracle.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
References: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a skeleton for the stack_user module.  It's just the barebones module
code.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/stack_user.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)
 create mode 100644 fs/ocfs2/stack_user.c

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
new file mode 100644
index 0000000..920eb11
--- /dev/null
+++ b/fs/ocfs2/stack_user.c
@@ -0,0 +1,38 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * stack_user.c
+ *
+ * Code which interfaces ocfs2 with fs/dlm and a userspace stack.
+ *
+ * Copyright (C) 2007 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation, version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/module.h>
+
+#include "stackglue.h"
+
+
+static int __init user_stack_init(void)
+{
+	return 0;
+}
+
+static void __exit user_stack_exit(void)
+{
+}
+
+MODULE_AUTHOR("Oracle");
+MODULE_DESCRIPTION("ocfs2 driver for userspace cluster stacks");
+MODULE_LICENSE("GPL");
+module_init(user_stack_init);
+module_exit(user_stack_exit);
-- 
1.5.3.8

