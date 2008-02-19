Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbYBSVTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbYBSVTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 16:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYBSVTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 16:19:13 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:40106 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbYBSVTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:19:12 -0500
Date: Tue, 19 Feb 2008 13:18:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: fix kernel-docbook parameters and files
Message-Id: <20080219131847.24f4659a.randy.dunlap@oracle.com>
In-Reply-To: <20080219204725.GM23197@kernel.dk>
References: <20080218130445.f5f5a205.randy.dunlap@oracle.com>
	<20080219204725.GM23197@kernel.dk>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

kernel-doc for block/:
- add missing parameters
- fix one function's parameter list (remove blank line)
- add 2 source files to docbook for non-exported kernel-doc functions

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/kernel-api.tmpl |    2 ++
 block/blk-core.c                      |    2 ++
 block/blk-settings.c                  |    1 -
 3 files changed, 4 insertions(+), 1 deletion(-)

--- linux-2.6.25-rc2-git3.orig/block/blk-core.c
+++ linux-2.6.25-rc2-git3/block/blk-core.c
@@ -1768,6 +1768,7 @@ static inline void __end_request(struct 
 
 /**
  * blk_rq_bytes - Returns bytes left to complete in the entire request
+ * @rq: the request being processed
  **/
 unsigned int blk_rq_bytes(struct request *rq)
 {
@@ -1780,6 +1781,7 @@ EXPORT_SYMBOL_GPL(blk_rq_bytes);
 
 /**
  * blk_rq_cur_bytes - Returns bytes left to complete in the current segment
+ * @rq: the request being processed
  **/
 unsigned int blk_rq_cur_bytes(struct request *rq)
 {
--- linux-2.6.25-rc2-git3.orig/block/blk-settings.c
+++ linux-2.6.25-rc2-git3/block/blk-settings.c
@@ -294,7 +294,6 @@ EXPORT_SYMBOL(blk_queue_stack_limits);
 
 /**
  * blk_queue_dma_drain - Set up a drain buffer for excess dma.
- *
  * @q:  the request queue for the device
  * @dma_drain_needed: fn which returns non-zero if drain is necessary
  * @buf:	physically contiguous buffer
--- linux-2.6.25-rc2-git3.orig/Documentation/DocBook/kernel-api.tmpl
+++ linux-2.6.25-rc2-git3/Documentation/DocBook/kernel-api.tmpl
@@ -361,12 +361,14 @@ X!Edrivers/pnp/system.c
   <chapter id="blkdev">
      <title>Block Devices</title>
 !Eblock/blk-core.c
+!Iblock/blk-core.c
 !Eblock/blk-map.c
 !Iblock/blk-sysfs.c
 !Eblock/blk-settings.c
 !Eblock/blk-exec.c
 !Eblock/blk-barrier.c
 !Eblock/blk-tag.c
+!Iblock/blk-tag.c
   </chapter>
 
   <chapter id="chrdev">
