Return-Path: <linux-kernel-owner+w=401wt.eu-S1761884AbYDTKsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761884AbYDTKsd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759403AbYDTKku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:40:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56340 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759351AbYDTKkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:40:49 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 25/36] SYSFS: Explicitly include required header file slab.h.
Date: Sun, 20 Apr 2008 03:45:55 -0700
Message-Id: <1208688366-9252-25-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert P. J. Day <rpjday@crashcourse.ca>

After an experimental deletion of the unnecessary inclusion of
<linux/slab.h> from the header file <linux/percpu.h>, the following
files under fs/sysfs were exposed as needing to explicitly include
<linux/slab.h>.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c  |    1 +
 fs/sysfs/file.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 4948d9b..a1c3a1f 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -20,6 +20,7 @@
 #include <linux/idr.h>
 #include <linux/completion.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include "sysfs.h"
 
 DEFINE_MUTEX(sysfs_mutex);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index baa663e..a859c32 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/kobject.h>
 #include <linux/kallsyms.h>
+#include <linux/slab.h>
 #include <linux/namei.h>
 #include <linux/poll.h>
 #include <linux/list.h>
-- 
1.5.4.5

