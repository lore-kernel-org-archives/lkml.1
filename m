Return-Path: <linux-kernel-owner+w=401wt.eu-S1760199AbZAMO0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbZAMO0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbZAMO02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:26:28 -0500
Received: from thunk.org ([69.25.196.29]:45326 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbZAMO02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:26:28 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] block: Fix documentation for blkdev_issue_flush()
Date: Tue, 13 Jan 2009 09:26:26 -0500
Message-Id: <1231856786-32685-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.0.4.8.g36f27.dirty
In-Reply-To: <20090113140706.GV30821@kernel.dk>
References: <20090113140706.GV30821@kernel.dk>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 block/blk-barrier.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 8eba4e4..f7dae57 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -302,7 +302,7 @@ static void bio_end_empty_barrier(struct bio *bio, int err)
  * Description:
  *    Issue a flush for the block device in question. Caller can supply
  *    room for storing the error offset in case of a flush error, if they
- *    wish to.  Caller must run wait_for_completion() on its own.
+ *    wish to.
  */
 int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
 {
-- 
1.6.0.4.8.g36f27.dirty

