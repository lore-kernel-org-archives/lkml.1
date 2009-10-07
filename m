Return-Path: <linux-kernel-owner+w=401wt.eu-S934020AbZJGICb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934020AbZJGICb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758739AbZJGICY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:02:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:28327 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758730AbZJGICV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:02:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971824"
Message-Id: <20091007074904.114952336@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li Shaohua" <shaohua.li@intel.com>,
       "Myklebust Trond" <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       <linux-fsdevel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 23/45] writeback: kill space in debugfs item name
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-fix-writeback-threads.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The space is not script friendly, kill it.

CC: Jens Axboe <jens.axboe@oracle.com> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/backing-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/mm/backing-dev.c	2009-10-06 23:38:44.000000000 +0800
+++ linux/mm/backing-dev.c	2009-10-06 23:38:45.000000000 +0800
@@ -94,7 +94,7 @@ static int bdi_debug_stats_show(struct s
 		   "DirtyThresh:      %8lu kB\n"
 		   "BackgroundThresh: %8lu kB\n"
 		   "WriteBandwidth:   %8lu kBps\n"
-		   "WriteBack threads:%8lu\n"
+		   "WriteBackThreads: %8lu\n"
 		   "b_dirty:          %8lu\n"
 		   "b_io:             %8lu\n"
 		   "b_more_io:        %8lu\n"


