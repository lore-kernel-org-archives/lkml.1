Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbYAOBE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbYAOBE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 20:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYAOBEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 20:04:20 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46014 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbYAOBET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 20:04:19 -0500
Date: Tue, 15 Jan 2008 10:03:23 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 5/5] /proc/zoneinfo enhancement
Cc: kosaki.motohiro@jp.fujitsu.com, Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080115092828.116F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080115092828.116F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080115100233.117E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

show new member of zone struct by /proc/zoneinfo.

Signed-off-by: Marcelo Tosatti <marcelo@kvack.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 mm/vmstat.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.24-rc6-mm1-memnotify/mm/vmstat.c
===================================================================
--- linux-2.6.24-rc6-mm1-memnotify.orig/mm/vmstat.c	2008-01-13 16:42:54.000000000 +0900
+++ linux-2.6.24-rc6-mm1-memnotify/mm/vmstat.c	2008-01-13 17:07:43.000000000 +0900
@@ -795,9 +795,11 @@ static void zoneinfo_show_print(struct s
 	seq_printf(m,
 		   "\n  all_unreclaimable: %u"
 		   "\n  prev_priority:     %i"
+		   "\n  mem_notify_status: %i"
 		   "\n  start_pfn:         %lu",
-			   zone_is_all_unreclaimable(zone),
+		   zone_is_all_unreclaimable(zone),
 		   zone->prev_priority,
+		   zone->mem_notify_status,
 		   zone->zone_start_pfn);
 	seq_putc(m, '\n');
 }


