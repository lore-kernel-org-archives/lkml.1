Return-Path: <linux-kernel-owner+w=401wt.eu-S1763990AbYDBU0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763990AbYDBU0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761639AbYDBURh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:17:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:33073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761619AbYDBURc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:17:32 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>
Subject: [PATCH 26/62] ocfs2: Add the user stack module.
Date: Wed,  2 Apr 2008 13:14:36 -0700
Message-Id: <12071673722691-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12071673701937-git-send-email-mfasheh@suse.com>
References: <12071673121124-git-send-email-mfasheh@suse.com>
 <1207167318479-git-send-email-mfasheh@suse.com>
 <12071673203909-git-send-email-mfasheh@suse.com>
 <12071673232465-git-send-email-mfasheh@suse.com>
 <12071673263948-git-send-email-mfasheh@suse.com>
 <12071673282579-git-send-email-mfasheh@suse.com>
 <1207167330482-git-send-email-mfasheh@suse.com>
 <12071673321172-git-send-email-mfasheh@suse.com>
 <12071673341888-git-send-email-mfasheh@suse.com>
 <12071673362069-git-send-email-mfasheh@suse.com>
 <12071673391031-git-send-email-mfasheh@suse.com>
 <12071673413492-git-send-email-mfasheh@suse.com>
 <1207167343926-git-send-email-mfasheh@suse.com>
 <12071673461268-git-send-email-mfasheh@suse.com>
 <12071673481928-git-send-email-mfasheh@suse.com>
 <12071673492775-git-send-email-mfasheh@suse.com>
 <12071673511262-git-send-email-mfasheh@suse.com>
 <12071673543752-git-send-email-mfasheh@suse.com>
 <1207167355295-git-send-email-mfasheh@suse.com>
 <12071673571757-git-send-email-mfasheh@suse.com>
 <12071673591158-git-send-email-mfasheh@suse.com>
 <12071673613757-git-send-email-mfasheh@suse.com>
 <1207167363119-git-send-email-mfasheh@suse.com>
 <12071673661674-git-send-email-mfasheh@suse.com>
 <12071673681650-git-send-email-mfasheh@suse.com>
 <12071673701937-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel Becker <joel.becker@oracle.com>

Add a skeleton for the stack_user module.  It's just the barebones module
code.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
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
1.5.4.1

