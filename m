Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbZDNBi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbZDNBi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 21:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZDNBiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 21:38:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:15859 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbZDNBiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 21:38:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,182,1239001200"; 
   d="scan'208";a="131088378"
Date: Tue, 14 Apr 2009 09:37:30 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] readahead: remove redundant test in
	shrink_readahead_size_eio()
Message-ID: <20090414013730.GA8951@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/filemap.c |    3 ---
 1 file changed, 3 deletions(-)

--- mm.orig/mm/filemap.c
+++ mm/mm/filemap.c
@@ -1072,9 +1072,6 @@ EXPORT_SYMBOL(grab_cache_page_nowait);
 static void shrink_readahead_size_eio(struct file *filp,
 					struct file_ra_state *ra)
 {
-	if (!ra->ra_pages)
-		return;
-
 	ra->ra_pages /= 4;
 }
 
