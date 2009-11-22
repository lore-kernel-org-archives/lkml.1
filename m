Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbZKVISJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbZKVISJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 03:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZKVISJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 03:18:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:49142 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbZKVISI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 03:18:08 -0500
Subject: [PATCH] writeback: Fix missing kernel-doc notation
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Randy Dunlap <randy.dunlap@oracle.com>, Jens Axboe <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Nov 2009 13:46:09 +0530
Message-Id: <1258877769.4495.48.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the following htmldocs warning:

  Warning(fs/fs-writeback.c:255): No description found for parameter 'sb'

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/fs-writeback.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 9d5360c..b15c97f 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -242,6 +242,7 @@ static void bdi_sync_writeback(struct backing_dev_info *bdi,
 /**
  * bdi_start_writeback - start writeback
  * @bdi: the backing device to write from
+ * @sb: write inodes from this super_block
  * @nr_pages: the number of pages to write
  *
  * Description:
-- 
1.6.5.3


