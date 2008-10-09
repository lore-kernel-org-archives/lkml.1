Return-Path: <linux-kernel-owner+w=401wt.eu-S1758642AbYJIGnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642AbYJIGnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 02:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbYJIGnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 02:43:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42561 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbYJIGnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 02:43:14 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
Subject: [mmotm 02/Oct PATCH 3/3] fix style issue of get_scan_ratio()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <20081009153432.DEC7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081009153432.DEC7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081009154146.DED0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  9 Oct 2008 15:43:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmscan-split-lru-lists-into-anon-file-sets.patch introduce two style issue.
this patch fix it.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1420,7 +1420,7 @@ static unsigned long shrink_list(enum lr
  * percent[0] specifies how much pressure to put on ram/swap backed
  * memory, while percent[1] determines pressure on the file LRUs.
  */
-static void get_scan_ratio(struct zone *zone, struct scan_control * sc,
+static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
 					unsigned long *percent)
 {
 	unsigned long anon, file, free;
@@ -1448,16 +1448,16 @@ static void get_scan_ratio(struct zone *
 	}
 
 	/*
-         * OK, so we have swap space and a fair amount of page cache
-         * pages.  We use the recently rotated / recently scanned
-         * ratios to determine how valuable each cache is.
-         *
-         * Because workloads change over time (and to avoid overflow)
-         * we keep these statistics as a floating average, which ends
-         * up weighing recent references more than old ones.
-         *
-         * anon in [0], file in [1]
-         */
+	 * OK, so we have swap space and a fair amount of page cache
+	 * pages.  We use the recently rotated / recently scanned
+	 * ratios to determine how valuable each cache is.
+	 *
+	 * Because workloads change over time (and to avoid overflow)
+	 * we keep these statistics as a floating average, which ends
+	 * up weighing recent references more than old ones.
+	 *
+	 * anon in [0], file in [1]
+	 */
 	if (unlikely(zone->recent_scanned[0] > anon / 4)) {
 		spin_lock_irq(&zone->lru_lock);
 		zone->recent_scanned[0] /= 2;


