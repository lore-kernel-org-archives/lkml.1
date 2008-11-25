Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbYKYEaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbYKYEaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 23:30:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYKYEaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 23:30:04 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46985 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbYKYEaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 23:30:02 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: make setup_per_zone_inactive_ratio() static
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081125131942.26CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081125131942.26CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081125132919.26DF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 25 Nov 2008 13:29:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse output following warning.

mm/page_alloc.c:4301:6: warning: symbol 'setup_per_zone_inactive_ratio' was not declared. Should it be static?

cleanup here.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c	2008-11-22 22:38:20.000000000 +0900
+++ b/mm/page_alloc.c	2008-11-22 22:38:40.000000000 +0900
@@ -4298,7 +4298,7 @@ void setup_per_zone_pages_min(void)
  *    1TB     101        10GB
  *   10TB     320        32GB
  */
-void setup_per_zone_inactive_ratio(void)
+static void setup_per_zone_inactive_ratio(void)
 {
 	struct zone *zone;
 


