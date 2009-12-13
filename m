Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbZLNAVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbZLNAVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbZLNAU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:20:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34057 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbZLMX5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:38 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, gregkh@suse.de,
       torvalds@linux-foundation.org
Subject: [PATCH 2/3] Constify struct block_device_operations for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:21 +0100
Message-Id: <8b484b633f53d7b2d607d9c33f5801462e9e930c.1260662995.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662995.git.re.emese@gmail.com>
References: <cover.1260662995.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/staging/dst/dcore.c             |    2 +-
 drivers/staging/hv/blkvsc_drv.c         |    2 +-
 drivers/staging/ramzswap/ramzswap_drv.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dst/dcore.c b/drivers/staging/dst/dcore.c
index fd5bd0e..1be5e2c 100644
--- a/drivers/staging/dst/dcore.c
+++ b/drivers/staging/dst/dcore.c
@@ -149,7 +149,7 @@ static int dst_bdev_release(struct gendisk *disk, fmode_t mode)
 	return 0;
 }
 
-static struct block_device_operations dst_blk_ops = {
+static const struct block_device_operations dst_blk_ops = {
 	.open		= dst_bdev_open,
 	.release	= dst_bdev_release,
 	.owner		= THIS_MODULE,
diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 62b2828..0a47695 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -153,7 +153,7 @@ static int blkvsc_ringbuffer_size = BLKVSC_RING_BUFFER_SIZE;
 /* The one and only one */
 static struct blkvsc_driver_context g_blkvsc_drv;
 
-static struct block_device_operations block_ops = {
+static const struct block_device_operations block_ops = {
 	.owner = THIS_MODULE,
 	.open = blkvsc_open,
 	.release = blkvsc_release,
diff --git a/drivers/staging/ramzswap/ramzswap_drv.c b/drivers/staging/ramzswap/ramzswap_drv.c
index b839f05..c5505a9 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.c
+++ b/drivers/staging/ramzswap/ramzswap_drv.c
@@ -1310,7 +1310,7 @@ out:
 	return ret;
 }
 
-static struct block_device_operations ramzswap_devops = {
+static const struct block_device_operations ramzswap_devops = {
 	.ioctl = ramzswap_ioctl,
 	.owner = THIS_MODULE,
 };
-- 
1.6.5.3

