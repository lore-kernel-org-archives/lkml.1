Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbZIIPH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbZIIPH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZIIPHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:07:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:65365 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbZIIPHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:07:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="185728202"
Message-Id: <20090909145141.293229693@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 09 Sep 2009 22:51:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
CC: Dave Chinner <david@fromorbit.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Christoph Hellwig <hch@infradead.org>
CC: jack@suse.cz
CC: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       <linux-fsdevel@vger.kernel.org>
Subject: [RFC][PATCH 0/7] some random writeback fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

These are some writeback fixes based on the latest linux-next without
the vm.max_writeback_mb knob, since I'm not aware of any strong reasons
for introducing it. Instead, the MAX_WRITEBACK_PAGES is directly increased
to 64MB.

Other patches are straightforward. Needs more tests but it's enough to show
the basic ideas. Comments are welcome!

Thanks,
Fengguang
-- 

