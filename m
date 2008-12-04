Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbYLDIQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbYLDIQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 03:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYLDIQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 03:16:07 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38545 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbYLDIQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 03:16:06 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [mmotm][PATCH] vmscan: style cleanup
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081204170937.1D7A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  4 Dec 2008 17:15:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied after: memcg-add-inactive_anon_is_low.patch

Balbir-san pointed out memcg-add-inactive_anon_is_low.patch has one
strange indent.

fix here.

Andrew, if you like folded patch instead incremental patch, 
please let me know it.


==

trivial style cleanup.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>
---
 mm/vmscan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1411,8 +1411,7 @@ static unsigned long shrink_list(enum lr
 		return 0;
 	}
 
-	if (lru == LRU_ACTIVE_ANON &&
-	    inactive_anon_is_low(zone, sc)) {
+	if (lru == LRU_ACTIVE_ANON && inactive_anon_is_low(zone, sc)) {
 		shrink_active_list(nr_to_scan, zone, sc, priority, file);
 		return 0;
 	}


