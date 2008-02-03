Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbYBCXGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbYBCXGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 18:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbYBCXGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 18:06:04 -0500
Received: from xenotime.net ([66.160.160.81]:45233 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752431AbYBCXGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 18:06:03 -0500
Date: Sun, 3 Feb 2008 15:05:59 -0800 (PST)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org
cc: axboe@kernel.dk, akpm@linux-foundation.org
Subject: [PATCH 2/8] kernel-doc: fix block params and docbook
Message-ID: <Pine.LNX.4.64.0802031428200.3021@shark.he.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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

--- linux-2.6.24-git12.orig/block/blk-core.c
+++ linux-2.6.24-git12/block/blk-core.c
@@ -1734,6 +1734,7 @@ static inline void __end_request(struct

  /**
   * blk_rq_bytes - Returns bytes left to complete in the entire request
+ * @rq: the request being processed
   **/
  unsigned int blk_rq_bytes(struct request *rq)
  {
@@ -1746,6 +1747,7 @@ EXPORT_SYMBOL_GPL(blk_rq_bytes);

  /**
   * blk_rq_cur_bytes - Returns bytes left to complete in the current segment
+ * @rq: the request being processed
   **/
  unsigned int blk_rq_cur_bytes(struct request *rq)
  {
--- linux-2.6.24-git12.orig/block/blk-settings.c
+++ linux-2.6.24-git12/block/blk-settings.c
@@ -294,7 +294,6 @@ EXPORT_SYMBOL(blk_queue_stack_limits);

  /**
   * blk_queue_dma_drain - Set up a drain buffer for excess dma.
- *
   * @q:  the request queue for the device
   * @buf:	physically contiguous buffer
   * @size:	size of the buffer in bytes
--- linux-2.6.24-git12.orig/Documentation/DocBook/kernel-api.tmpl
+++ linux-2.6.24-git12/Documentation/DocBook/kernel-api.tmpl
@@ -420,12 +420,14 @@ X!Edrivers/pnp/system.c
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
