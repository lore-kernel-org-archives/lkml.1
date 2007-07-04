Return-Path: <linux-kernel-owner+w=401wt.eu-S1758986AbXGDMaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986AbXGDMaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 08:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761844AbXGDM3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 08:29:43 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:59043 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761650AbXGDM3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 08:29:41 -0400
Date: Wed, 4 Jul 2007 15:29:37 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/11] mm/page_alloc.c: lower printk severity
Message-ID: <0b503b78b62d54cf61063ca12a6040ace083e16e.1183551645.git.da-x@monatomic.org>
References: <6789b0ff288d584d640ee65f8e1e5e27bf040862.1183551644.git.da-x@monatomic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6789b0ff288d584d640ee65f8e1e5e27bf040862.1183551644.git.da-x@monatomic.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dan Aloni <da-x@monatomic.org>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 05ace44..b324bc2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3361,7 +3361,7 @@ void *__init alloc_large_system_hash(const char *tablename,
 	if (!table)
 		panic("Failed to allocate %s hash table\n", tablename);
 
-	printk("%s hash table entries: %d (order: %d, %lu bytes)\n",
+	printk(KERN_INFO "%s hash table entries: %d (order: %d, %lu bytes)\n",
 	       tablename,
 	       (1U << log2qty),
 	       ilog2(size) - PAGE_SHIFT,
-- 
1.4.4.3


-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
