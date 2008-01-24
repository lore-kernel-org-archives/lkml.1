Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbYAXEXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbYAXEXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 23:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbYAXEXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 23:23:25 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35154 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbYAXEXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 23:23:24 -0500
Date: Thu, 24 Jan 2008 13:22:46 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 5/8] mem_notify v5: add new mem_notify field to /proc/zoneinfo
Cc: kosaki.motohiro@jp.fujitsu.com, Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080124130348.1760.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080124130348.1760.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080124132204.176F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

show new member of zone struct by /proc/zoneinfo.

ChangeLog:
	v5: change display order to at last.


Signed-off-by: Marcelo Tosatti <marcelo@kvack.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 mm/vmstat.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: b/mm/vmstat.c
===================================================================
--- a/mm/vmstat.c	2008-01-23 22:06:05.000000000 +0900
+++ b/mm/vmstat.c	2008-01-23 22:08:00.000000000 +0900
@@ -795,10 +795,12 @@ static void zoneinfo_show_print(struct s
 	seq_printf(m,
 		   "\n  all_unreclaimable: %u"
 		   "\n  prev_priority:     %i"
-		   "\n  start_pfn:         %lu",
-			   zone_is_all_unreclaimable(zone),
+		   "\n  start_pfn:         %lu"
+		   "\n  mem_notify_status: %i",
+		   zone_is_all_unreclaimable(zone),
 		   zone->prev_priority,
-		   zone->zone_start_pfn);
+		   zone->zone_start_pfn,
+		   zone->mem_notify_status);
 	seq_putc(m, '\n');
 }
 



