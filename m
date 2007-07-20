Return-Path: <linux-kernel-owner+w=401wt.eu-S1759126AbXGTKNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126AbXGTKNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 06:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbXGTKLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 06:11:34 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:59099 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752338AbXGTKLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 06:11:30 -0400
Message-ID: <384926279.22018@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070720100740.106917381@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Fri, 20 Jul 2007 18:07:40 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] readahead cleanups and interleaved readahead
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

The following readahead updates have been tested and should be OK for 2.6.23 :-)

smaller file_ra_state:
   [PATCH 1/6] compacting file_ra_state
   [PATCH 2/6] mmap read-around simplification

code cleanups:
   [PATCH 3/6] remove several readahead macros
   [PATCH 4/6] remove the limit max_sectors_kb imposed on max_readahead_kb

support of interleaved reads:
   [PATCH 5/6] introduce radix_tree_scan_hole()
   [PATCH 6/6] basic support of interleaved reads


The diffstat is

 block/ll_rw_blk.c          |    9 ------
 include/linux/fs.h         |   13 ++++-----
 include/linux/mm.h         |    2 -
 include/linux/radix-tree.h |    2 +
 lib/radix-tree.c           |   34 ++++++++++++++++++++++++
 mm/filemap.c               |    6 ++--
 mm/readahead.c             |   48 +++++++++++++++++++----------------
 7 files changed, 72 insertions(+), 42 deletions(-)


Regards,
Fengguang Wu
