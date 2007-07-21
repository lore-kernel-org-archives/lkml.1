Return-Path: <linux-kernel-owner+w=401wt.eu-S940321AbXGUPMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940321AbXGUPMI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939257AbXGUPEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:04:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:39272 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938633AbXGUPEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:04:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=Y382nhJWcVy9vA42sXFxNJuSU82MCG1pGK8iFSGvVNGZODGrZMlsbdmLgydo7VyZQeNBLZqcNaY5X2IcuXntfxNm4CZYSOJWCzb4nsxdC2g/TYHkYEnNfsRIzo2R6Y/uoCb4UDF7oGiPBFHg8nxcF8HsAoaHOvFQNgMtJA7jETA=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][19/37] Clean up duplicate includes in fs/gfs2/
Date: Sat, 21 Jul 2007 17:03:22 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, cluster-devel@redhat.com,
       Steven Whitehouse <swhiteho@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211703.23149.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	fs/gfs2/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 3f0974e..0c21be0 100644
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
