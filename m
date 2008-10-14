Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbYJNGer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbYJNGer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 02:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbYJNGeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 02:34:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60982 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbYJNGeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 02:34:23 -0400
Message-ID: <48F43D64.8000806@cn.fujitsu.com>
Date: Tue, 14 Oct 2008 14:34:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: fix kernel-doc for blk_alloc_devt()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No argument 'gfp_mask' for blk_alloc_devt().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 block/genhd.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 4cd3433..b8defae 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -358,7 +358,6 @@ static int blk_mangle_minor(int minor)
 /**
  * blk_alloc_devt - allocate a dev_t for a partition
  * @part: partition to allocate dev_t for
- * @gfp_mask: memory allocation flag
  * @devt: out parameter for resulting dev_t
  *
  * Allocate a dev_t for block device.
-- 
1.5.4.rc3

