Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbZJLCDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbZJLCDg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 22:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbZJLCDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 22:03:35 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:57591 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbZJLCDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 22:03:34 -0400
Message-ID: <4AD28E10.3010502@oracle.com>
Date: Sun, 11 Oct 2009 19:01:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, jens.axboe@oracle.com
Subject: [PATCH] blk-settings: fix function parameter kernel-doc notation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B020A.4AD28E4F.00B4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc notation in blk-settings.c::blk_queue_max_discard_sectors().

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 block/blk-settings.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.32-rc3-git1.orig/block/blk-settings.c
+++ linux-2.6.32-rc3-git1/block/blk-settings.c
@@ -242,7 +242,7 @@ EXPORT_SYMBOL(blk_queue_max_hw_sectors);
 /**
  * blk_queue_max_discard_sectors - set max sectors for a single discard
  * @q:  the request queue for the device
- * @max_discard: maximum number of sectors to discard
+ * @max_discard_sectors: maximum number of sectors to discard
  **/
 void blk_queue_max_discard_sectors(struct request_queue *q,
 		unsigned int max_discard_sectors)
