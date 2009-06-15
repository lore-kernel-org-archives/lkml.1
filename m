Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbZFODuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbZFODuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 23:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZFODuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 23:50:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50096 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbZFODuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 23:50:06 -0400
Message-ID: <4A35C547.3090109@cn.fujitsu.com>
Date: Mon, 15 Jun 2009 11:51:35 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: remove some includings of blktrace_api.h
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When porting blktrace to tracepoints, we changed to trace/block.h
for trace prober declarations.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 block/blk-core.c      |    1 -
 drivers/block/cciss.c |    1 -
 drivers/md/dm.c       |    1 -
 fs/bio.c              |    1 -
 mm/bounce.c           |    1 -
 mm/highmem.c          |    1 -
 6 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f6452f6..5797f58 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -26,7 +26,6 @@
 #include <linux/swap.h>
 #include <linux/writeback.h>
 #include <linux/task_io_accounting_ops.h>
-#include <linux/blktrace_api.h>
 #include <linux/fault-inject.h>
 
 #define CREATE_TRACE_POINTS
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index b22cec9..c7a527c 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -38,7 +38,6 @@
 #include <linux/hdreg.h>
 #include <linux/spinlock.h>
 #include <linux/compat.h>
-#include <linux/blktrace_api.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3fd8b1e..48db308 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -19,7 +19,6 @@
 #include <linux/slab.h>
 #include <linux/idr.h>
 #include <linux/hdreg.h>
-#include <linux/blktrace_api.h>
 
 #include <trace/events/block.h>
 
diff --git a/fs/bio.c b/fs/bio.c
index 5f80848..24c9140 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -25,7 +25,6 @@
 #include <linux/module.h>
 #include <linux/mempool.h>
 #include <linux/workqueue.h>
-#include <linux/blktrace_api.h>
 #include <scsi/sg.h>		/* for struct sg_iovec */
 
 #include <trace/events/block.h>
diff --git a/mm/bounce.c b/mm/bounce.c
index 4ebe3ea..a2b76a5 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -13,7 +13,6 @@
 #include <linux/init.h>
 #include <linux/hash.h>
 #include <linux/highmem.h>
-#include <linux/blktrace_api.h>
 #include <asm/tlbflush.h>
 
 #include <trace/events/block.h>
diff --git a/mm/highmem.c b/mm/highmem.c
index 68eb1d9..25878cc 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -26,7 +26,6 @@
 #include <linux/init.h>
 #include <linux/hash.h>
 #include <linux/highmem.h>
-#include <linux/blktrace_api.h>
 #include <asm/tlbflush.h>
 
 /*
-- 
1.5.4.rc3
