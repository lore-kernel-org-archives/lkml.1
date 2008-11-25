Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbYKYE0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbYKYE0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 23:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbYKYE0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 23:26:44 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46631 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbYKYE0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 23:26:43 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: make mem_cgroup_resize_limit() static
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081125131942.26CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081125131942.26CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081125132556.26D6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 25 Nov 2008 13:26:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse output following warnings.

mm/memcontrol.c:782:5: warning: symbol 'mem_cgroup_resize_limit' was not declared. Should it be static?

cleanup here.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: b/mm/memcontrol.c
===================================================================
--- a/mm/memcontrol.c	2008-11-05 01:11:45.000000000 +0900
+++ b/mm/memcontrol.c	2008-11-22 22:23:12.000000000 +0900
@@ -779,7 +779,8 @@ int mem_cgroup_shrink_usage(struct mm_st
 	return 0;
 }
 
-int mem_cgroup_resize_limit(struct mem_cgroup *memcg, unsigned long long val)
+static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
+				   unsigned long long val)
 {
 
 	int retry_count = MEM_CGROUP_RECLAIM_RETRIES;


