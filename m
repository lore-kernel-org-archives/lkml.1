Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbYICWPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbYICWPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 18:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYICWP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 18:15:26 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:8051 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbYICWPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 18:15:24 -0400
X-BigFish: VPS-26(zz13e6IL1403Rzz10d3izzed1kz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
Message-ID: <48BF0C77.6020901@am.sony.com>
Date: Wed, 3 Sep 2008 15:15:19 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: axboe@kernel.dk
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch] block: Minor comment fix
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2008 22:15:20.0347 (UTC) FILETIME=[8D87FEB0:01C90E12]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor fix to the inline documentation of blk_release_queue().

Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
---

Hi Jens,

Seems like this comment is in error.

-Geoff

 block/blk-sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -245,27 +245,27 @@ queue_attr_store(struct kobject *kobj, s
 	mutex_lock(&q->sysfs_lock);
 	if (test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)) {
 		mutex_unlock(&q->sysfs_lock);
 		return -ENOENT;
 	}
 	res = entry->store(q, page, length);
 	mutex_unlock(&q->sysfs_lock);
 	return res;
 }
 
 /**
- * blk_cleanup_queue: - release a &struct request_queue when it is no longer needed
+ * blk_release_queue: - release a &struct request_queue when it is no longer needed
  * @kobj:    the kobj belonging of the request queue to be released
  *
  * Description:
- *     blk_cleanup_queue is the pair to blk_init_queue() or
+ *     blk_release_queue is the pair to blk_init_queue() or
  *     blk_queue_make_request().  It should be called when a request queue is
  *     being released; typically when a block device is being de-registered.
  *     Currently, its primary task it to free all the &struct request
  *     structures that were allocated to the queue and the queue itself.
  *
  * Caveat:
  *     Hopefully the low level driver will have finished any
  *     outstanding requests first...
  **/
 static void blk_release_queue(struct kobject *kobj)
 {

