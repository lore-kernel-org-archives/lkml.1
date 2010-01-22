Return-Path: <linux-kernel-owner+w=401wt.eu-S1752934Ab0AVFTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab0AVFTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 00:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005Ab0AVFTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 00:19:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:3590 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab0AVFT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 00:19:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="235591711"
Message-Id: <20100122045914.993668874@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 12:59:14 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Greg Kroah-Hartman <gregkh@suse.de>
cc: <stable@kernel.org>
cc: Andi Kleen <andi@firstfloor.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 0/4] devmem and readahead fixes for 2.6.33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Here are some good fixes for 2.6.33, they have been floating around
with other patches for some time. I should really seperate them out
earlier..

Greg,

The first two patches are on devmem. 2.6.32 also needs fixing, however
the patches can only apply cleanly to 2.6.33. I can do backporting if
necessary.

	[PATCH 1/4] devmem: check vmalloc address on kmem read/write
	[PATCH 2/4] devmem: fix kmem write bug on memory holes

The next two patches are on readahead. All previous kernel needs fixing,
and the patches can apply cleanly to 2.6.32, too.

	[PATCH 3/4] vfs: take f_lock on modifying f_mode after open time
	[PATCH 4/4] readahead: introduce FMODE_RANDOM for POSIX_FADV_RANDOM

Thanks,
Fengguang

