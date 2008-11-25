Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYKYE2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYKYE2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 23:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYKYE2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 23:28:14 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46721 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbYKYE2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 23:28:13 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: make scan_all_zones_unevictable_pages() static
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081125131942.26CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081125131942.26CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081125132641.26D9.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 25 Nov 2008 13:28:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse output following warning.

	mm/vmscan.c:2549:6: warning: symbol 'scan_all_zones_unevictable_pages' was not declared. Should it be static?

cleanup here.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c	2008-11-22 21:45:21.000000000 +0900
+++ b/mm/vmscan.c	2008-11-22 21:49:46.000000000 +0900
@@ -2546,7 +2546,7 @@ static void scan_zone_unevictable_pages(
  * that has possibly/probably made some previously unevictable pages
  * evictable.
  */
-void scan_all_zones_unevictable_pages(void)
+static void scan_all_zones_unevictable_pages(void)
 {
 	struct zone *zone;
 


