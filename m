Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbYGYTDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbYGYTDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 15:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755503AbYGYTD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 15:03:26 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:56875 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471AbYGYTDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 15:03:25 -0400
Date: Fri, 25 Jul 2008 23:03:19 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [2/3] POHMELFS high performance network filesystem. VFS changes.
Message-ID: <20080725190318.GC30685@2ka.mipt.ru>
References: <20080725190134.GA30685@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725190134.GA30685@2ka.mipt.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial VFS changes.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>


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
