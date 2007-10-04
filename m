Return-Path: <linux-kernel-owner+w=401wt.eu-S1759445AbXJDJTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445AbXJDJTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759362AbXJDJRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759282AbXJDJRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:22 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/51] [GFS2] Clean up duplicate includes in fs/gfs2/
Date: Thu,  4 Oct 2007 09:48:56 +0100
Message-Id: <11914877952291-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914877934041-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	fs/gfs2/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 6b6ae45..d403fd7 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -25,8 +25,6 @@
 #include <asm/uaccess.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
-#include <linux/module.h>
-#include <linux/kallsyms.h>
 
 #include "gfs2.h"
 #include "incore.h"
diff --git a/fs/gfs2/locking/dlm/lock_dlm.h b/fs/gfs2/locking/dlm/lock_dlm.h
index 24d70f7..9e8265d 100644
--- a/fs/gfs2/locking/dlm/lock_dlm.h
+++ b/fs/gfs2/locking/dlm/lock_dlm.h
@@ -13,7 +13,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/list.h>
diff --git a/fs/gfs2/locking/nolock/main.c b/fs/gfs2/locking/nolock/main.c
index 0d149c8..d3b8ce6 100644
--- a/fs/gfs2/locking/nolock/main.c
+++ b/fs/gfs2/locking/nolock/main.c
@@ -9,7 +9,6 @@
 
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/fs.h>
-- 
1.5.1.2

