Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbZDLHWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbZDLHWf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 03:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbZDLHWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 03:22:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:11423 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739AbZDLHWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 03:22:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,174,1239001200"; 
   d="scan'208";a="130525005"
Message-Id: <20090412071950.166891982@intel.com>
User-Agent: quilt/0.46-1
Date: Sun, 12 Apr 2009 15:19:50 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] context readahead for concurrent IO take 2
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

