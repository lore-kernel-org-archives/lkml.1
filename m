Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab0CDDKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:10:44 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:52374 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab0CDDKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:10:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=hMDJQYNs9NEf5yXQYtIF2LxgxG1DvzZkZzn0s/oYhQA/irnwdYQtzQ2IOI7JV9jwOP
         SmpkND7k01vy6HjzFTXyFta3hAWa6KENaaRS9iJrkj8GFB109ELx35/qAefKa9XF9ADo
         VYv6iZCo5Lhcp/ZFAjP2IblClh84Veo65puuA=
Date: Thu, 4 Mar 2010 19:09:16 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org
Subject: [PATCH] mm: Fix some coding styles on mm/ tree
Message-ID: <20100304110916.GA3197@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some coding styles on mm/ tree.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 mm/filemap.c     |   10 ++++------
 mm/filemap_xip.c |    3 +--
 mm/slab.c        |    8 ++++----
 mm/vmscan.c      |    4 ++--
 4 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 698ea80..4c48e87 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2001,9 +2001,8 @@ inline int generic_write_checks(struct file *file, loff_t *pos, size_t *count, i
 				send_sig(SIGXFSZ, current, 0);
 				return -EFBIG;
 			}
-			if (*count > limit - (typeof(limit))*pos) {
+			if (*count > limit - (typeof(limit))*pos)
 				*count = limit - (typeof(limit))*pos;
-			}
 		}
 	}
 
@@ -2012,12 +2011,11 @@ inline int generic_write_checks(struct file *file, loff_t *pos, size_t *count, i
 	 */
 	if (unlikely(*pos + *count > MAX_NON_LFS &&
 				!(file->f_flags & O_LARGEFILE))) {
-		if (*pos >= MAX_NON_LFS) {
+		if (*pos >= MAX_NON_LFS)
 			return -EFBIG;
-		}
-		if (*count > MAX_NON_LFS - (unsigned long)*pos) {
+
+		if (*count > MAX_NON_LFS - (unsigned long)*pos)
 			*count = MAX_NON_LFS - (unsigned long)*pos;
-		}
 	}
 
 	/*
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index 1888b2d..56acab8 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -84,9 +84,8 @@ do_xip_mapping_read(struct address_space *mapping,
 			if (index > end_index)
 				goto out;
 			nr = ((isize - 1) & ~PAGE_CACHE_MASK) + 1;
-			if (nr <= offset) {
+			if (nr <= offset)
 				goto out;
-			}
 		}
 		nr = nr - offset;
 		if (nr > len - copied)
diff --git a/mm/slab.c b/mm/slab.c
index 7451bda..18418e1 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2216,13 +2216,13 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 	}
 
 	/* 2) arch mandated alignment */
-	if (ralign < ARCH_SLAB_MINALIGN) {
+	if (ralign < ARCH_SLAB_MINALIGN)
 		ralign = ARCH_SLAB_MINALIGN;
-	}
+
 	/* 3) caller mandated alignment */
-	if (ralign < align) {
+	if (ralign < align)
 		ralign = align;
-	}
+
 	/* disable debug if necessary */
 	if (ralign > __alignof__(unsigned long long))
 		flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c26986c..fbe2793 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1327,9 +1327,9 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 	 * zone->pages_scanned is used for detect zone's oom
 	 * mem_cgroup remembers nr_scan by itself.
 	 */
-	if (scanning_global_lru(sc)) {
+	if (scanning_global_lru(sc))
 		zone->pages_scanned += pgscanned;
-	}
+
 	reclaim_stat->recent_scanned[file] += nr_taken;
 
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
-- 
1.6.5.3

