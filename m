Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbZGNJ6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbZGNJ6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 05:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754428AbZGNJ6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 05:58:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56331 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754424AbZGNJ6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 05:58:48 -0400
Message-ID: <4A5C56E9.2000409@cn.fujitsu.com>
Date: Tue, 14 Jul 2009 17:59:05 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Small cleanup for z2ram.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should use Z2MINOR_COUNT as range argument in blk_unregister_region()

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 drivers/block/z2ram.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index 4575171..b259040 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -374,7 +374,7 @@ err:
 static void __exit z2_exit(void)
 {
     int i, j;
-    blk_unregister_region(MKDEV(Z2RAM_MAJOR, 0), 256);
+    blk_unregister_region(MKDEV(Z2RAM_MAJOR, 0), Z2MINOR_COUNT);
     unregister_blkdev(Z2RAM_MAJOR, DEVICE_NAME);
     del_gendisk(z2ram_gendisk);
     put_disk(z2ram_gendisk);
-- 
1.5.5.3


