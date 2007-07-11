Return-Path: <linux-kernel-owner+w=401wt.eu-S1763877AbXGKMTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763877AbXGKMTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760739AbXGKMTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:19:17 -0400
Received: from smtp.qwerty.ru ([87.240.2.134]:57434 "EHLO smtp.qwerty.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756121AbXGKMTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:19:17 -0400
Date: Wed, 11 Jul 2007 16:14:10 +0400
From: Kirill Kuvaldin <kuvkir@epsmu.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fixing the comment in mm/filemap.c
Message-ID: <20070711121410.GD4536@zetta.epsmu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: EpsMu Inc.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Seems that generic_file_write is no longer available, and
generic_file_buffered_write should be referred instead.
This makes the comment consistent.

Signed-off-by: Kirill Kuvaldin <kuvkir@epsmu.com>

diff --git a/mm/filemap.c b/mm/filemap.c
index edb1b0b..0a8b71e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1846,7 +1846,7 @@ EXPORT_SYMBOL(read_cache_page);
 /*
  * If the page was newly created, increment its refcount and add it to the
  * caller's lru-buffering pagevec.  This function is specifically for
- * generic_file_write().
+ * generic_file_buffered_write().
  */
 static inline struct page *
 __grab_cache_page(struct address_space *mapping, unsigned long index,
