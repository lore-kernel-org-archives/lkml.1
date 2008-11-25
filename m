Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYKYEZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYKYEZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 23:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYKYEZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 23:25:03 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46554 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbYKYEZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 23:25:01 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: make init_section_page_cgroup() static
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081125131942.26CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081125131942.26CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081125132405.26D0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 25 Nov 2008 13:24:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse output following warning.

mm/page_cgroup.c:100:15: warning: symbol 'init_section_page_cgroup' was not declared. Should it be static?

cleanup here.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/page_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/mm/page_cgroup.c
===================================================================
--- a/mm/page_cgroup.c	2008-11-05 01:11:45.000000000 +0900
+++ b/mm/page_cgroup.c	2008-11-22 22:24:06.000000000 +0900
@@ -97,7 +97,7 @@ struct page_cgroup *lookup_page_cgroup(s
 	return section->page_cgroup + pfn;
 }
 
-int __meminit init_section_page_cgroup(unsigned long pfn)
+static int __meminit init_section_page_cgroup(unsigned long pfn)
 {
 	struct mem_section *section;
 	struct page_cgroup *base, *pc;


