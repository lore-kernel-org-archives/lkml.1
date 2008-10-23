Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbYJWS6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbYJWS6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 14:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757513AbYJWS5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 14:57:47 -0400
Received: from netgear.net.ru ([195.178.208.66]:40767 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753561AbYJWS5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 14:57:46 -0400
Date: Thu, 23 Oct 2008 22:57:44 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Subject: [3/3] POHMELFS: VFS changes (2 exports).
Message-ID: <20081023185744.GC18562@2ka.mipt.ru>
References: <20081023185435.GA18461@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023185435.GA18461@2ka.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>

diff --git a/mm/filemap.c b/mm/filemap.c
index 07e9d92..57beb4b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -495,6 +495,7 @@ int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 		lru_cache_add(page);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(add_to_page_cache_lru);
 
 #ifdef CONFIG_NUMA
 struct page *__page_cache_alloc(gfp_t gfp)
@@ -610,6 +611,7 @@ int __lock_page_killable(struct page *page)
 	return __wait_on_bit_lock(page_waitqueue(page), &wait,
 					sync_page_killable, TASK_KILLABLE);
 }
+EXPORT_SYMBOL_GPL(__lock_page_killable);
 
 /**
  * __lock_page_nosync - get a lock on the page, without calling sync_page()



-- 
	Evgeniy Polyakov
