Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbXJ2Gbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbXJ2Gbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 02:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbXJ2Gbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 02:31:42 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:36273 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbXJ2Gbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 02:31:41 -0400
Message-ID: <47257E39.5060101@sw.ru>
Date: Mon, 29 Oct 2007 09:31:21 +0300
From: Vasily Averin <vvs@sw.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: i2o: debug messages corrected
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

max_phys_segments and max_sectors were swapped

Signed-off-by:	Vasily Averin <vvs@sw.ru>

--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -1076,8 +1076,8 @@ static int i2o_block_probe(struct device *dev)
 	blk_queue_max_sectors(queue, max_sectors);
 	blk_queue_max_hw_segments(queue, i2o_sg_tablesize(c, body_size));

-	osm_debug("max sectors = %d\n", queue->max_phys_segments);
-	osm_debug("phys segments = %d\n", queue->max_sectors);
+	osm_debug("max sectors = %d\n", queue->max_sectors);
+	osm_debug("phys segments = %d\n", queue->max_phys_segments);
 	osm_debug("max hw segments = %d\n", queue->max_hw_segments);

 	/*

