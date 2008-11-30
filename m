Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbYK3LOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbYK3LOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 06:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYK3LOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 06:14:37 -0500
Received: from fgwnews.fujitsu.co.jp ([164.71.1.134]:37046 "EHLO
	fgwnews.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbYK3LOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 06:14:37 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: kill zone_is_near_oom()
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081130201255.8162.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Sun, 30 Nov 2008 20:14:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, zone_is_ner_oom() is unused.
it can be removed.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    5 -----
 1 file changed, 5 deletions(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1220,11 +1220,6 @@ static inline void note_zone_scanning_pr
 		zone->prev_priority = priority;
 }
 
-static inline int zone_is_near_oom(struct zone *zone)
-{
-	return zone->pages_scanned >= (zone_lru_pages(zone) * 3);
-}
-
 /*
  * This moves pages from the active list to the inactive list.
  *



