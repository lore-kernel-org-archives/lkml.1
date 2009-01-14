Return-Path: <linux-kernel-owner+w=401wt.eu-S1760396AbZANHpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760396AbZANHpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 02:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbZANHpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 02:45:23 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:5297 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbZANHpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 02:45:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:bcc:subject:date:user-agent;
        b=IxpAvrjtGIe8w/0q2JX+2Jn5oUpAYJ49N1QMo6indNVV0fTLUYr3WU7Os/BIH48yRl
         UMkoS83ZR2l7CV2ci64OAAmS5NFsOuKoYpMAB2SKixrBb4dtlg3tralr+ZCl1e1QpNdB
         KtpRPIjxQvaMQls1Ya3LpWAYQ+RriwkZHi8nA=
Message-ID: <496d980e.160d6e0a.14d0.ffffbe3d@mx.google.com>
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] SYSFS: use standard magic.h for sysfs 
Date: Wed, 14 Jan 2009 15:45:13 +0800
User-Agent: sniper-patch-carrier/1.06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SYSFS_MAGIC has been added into magic.h, so only use that definition
in magic.h to avoid potential consistency problem.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
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

