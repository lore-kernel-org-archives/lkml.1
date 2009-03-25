Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbZCYAkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbZCYAkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbZCYAaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:10 -0400
Received: from kroah.org ([198.145.64.141]:54117 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754000AbZCYAaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Qinghuang Feng <qhfeng.kernel@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 30/61] SYSFS: use standard magic.h for sysfs
Date: Tue, 24 Mar 2009 17:26:34 -0700
Message-Id: <1237940825-22904-30-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qinghuang Feng <qhfeng.kernel@gmail.com>

SYSFS_MAGIC has been added into magic.h, so only use that definition
in magic.h to avoid potential consistency problem.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/mount.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index ab343e3..8133ca3 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -17,11 +17,10 @@
 #include <linux/pagemap.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/magic.h>
 
 #include "sysfs.h"
 
-/* Random magic number */
-#define SYSFS_MAGIC 0x62656572
 
 static struct vfsmount *sysfs_mount;
 struct super_block * sysfs_sb = NULL;
-- 
1.6.2

