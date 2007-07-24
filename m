Return-Path: <linux-kernel-owner+w=401wt.eu-S1764665AbXGXCMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764665AbXGXCMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 22:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759678AbXGXCMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 22:12:14 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:40618 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755978AbXGXCMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 22:12:13 -0400
Message-ID: <385243122.22147@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070724020009.677809022@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Tue, 24 Jul 2007 10:00:09 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/10] readahead cleanups and interleaved readahead take 4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Here are some more readahead related cleanups and updates.

smaller file_ra_state:
	[PATCH 01/10] readahead: compacting file_ra_state                             
	[PATCH 02/10] readahead: mmap read-around simplification                      
	[PATCH 03/10] readahead: combine file_ra_state.prev_index/prev_offset into prev_pos

Interleaved readahead:
	[PATCH 04/10] radixtree: introduce radix_tree_scan_hole()                     
	[PATCH 05/10] readahead: basic support of interleaved reads                   

Readahead cleanups:
	[PATCH 06/10] readahead: remove several readahead macros                      
	[PATCH 07/10] readahead: remove the limit max_sectors_kb imposed on max_readahead_kb
	[PATCH 08/10] readahead: remove the local copy of ra in do_generic_mapping_read()

Filemap cleanups:
	[PATCH 09/10] filemap: trivial code cleanups                                  
	[PATCH 10/10] filemap: convert some unsigned long to pgoff_t                  

The diffstat is

 block/ll_rw_blk.c          |    9 ----
 fs/ext3/dir.c              |    2 -
 fs/ext4/dir.c              |    2 -
 fs/splice.c                |    2 -
 include/linux/fs.h         |   14 +++----
 include/linux/mm.h         |    2 -
 include/linux/pagemap.h    |   23 ++++++------
 include/linux/radix-tree.h |    2 +
 lib/radix-tree.c           |   36 +++++++++++++++++++
 mm/filemap.c               |   65 ++++++++++++++++-------------------
 mm/readahead.c             |   58 +++++++++++++++++--------------
 11 files changed, 122 insertions(+), 93 deletions(-)

Regards,
Fengguang Wu
--
