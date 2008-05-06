Return-Path: <linux-kernel-owner+w=401wt.eu-S1762838AbYEFJnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762838AbYEFJnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbYEFJnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:43:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64473 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbYEFJnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:43:08 -0400
Message-ID: <482027E4.6030300@cn.fujitsu.com>
Date: Tue, 06 May 2008 17:41:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: clameter@sgi.com, LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/page_alloc.c: fix a typo
References: <4820272C.4060009@cn.fujitsu.com>
In-Reply-To: <4820272C.4060009@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bdd5c43..d0ba10d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -303,7 +303,7 @@ static void destroy_compound_page(struct page *page, unsigned long order)
 	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
 
-		if (unlikely(!PageTail(p) |
+		if (unlikely(!PageTail(p) ||
 				(p->first_page != page)))
 			bad_page(page);
 		__ClearPageTail(p);
-- 1.5.4.rc3 
