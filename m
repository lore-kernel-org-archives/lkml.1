Return-Path: <linux-kernel-owner+w=401wt.eu-S935624AbZDJNTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935624AbZDJNTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 09:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758453AbZDJNS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 09:18:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:5340 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbZDJNS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 09:18:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,166,1239001200"; 
   d="scan'208";a="130105027"
Message-Id: <20090410131247.764370473@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 10 Apr 2009 21:12:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] context readahead for concurrent IO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

The context readahead patches have been floating around for a while.  Now that
Vladislav confirmed that it helps SCST IO performance, I'd like to push it for
more -mm testing outs. I believe this will help many concurrent IO workloads,
to name a few: NFS, SCST and even lighttpd.

The patchset is against linux-next, after the earlier filemap and readahead
cleanup/fix patches.

Thanks,
Fengguang
-- 

