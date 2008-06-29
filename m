Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbYF2KOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbYF2KOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 06:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbYF2KOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 06:14:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48087 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586AbYF2KOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 06:14:38 -0400
Date: Sun, 29 Jun 2008 19:12:16 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] kill unused lru functions
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080629190905.37CF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

several LRU manupuration function is not used now.
So, it can be removed.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 include/linux/mm_inline.h |   48 ----------------------------------------------
 1 file changed, 48 deletions(-)

Index: b/include/linux/mm_inline.h
===================================================================
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -38,54 +38,6 @@ del_page_from_lru_list(struct zone *zone
 }
 
 static inline void
-add_page_to_inactive_anon_list(struct zone *zone, struct page *page)
-{
-	add_page_to_lru_list(zone, page, LRU_INACTIVE_ANON);
-}
-
-static inline void
-add_page_to_active_anon_list(struct zone *zone, struct page *page)
-{
-	add_page_to_lru_list(zone, page, LRU_ACTIVE_ANON);
-}
-
-static inline void
-add_page_to_inactive_file_list(struct zone *zone, struct page *page)
-{
-	add_page_to_lru_list(zone, page, LRU_INACTIVE_FILE);
-}
-
-static inline void
-add_page_to_active_file_list(struct zone *zone, struct page *page)
-{
-	add_page_to_lru_list(zone, page, LRU_ACTIVE_FILE);
-}
-
-static inline void
-del_page_from_inactive_anon_list(struct zone *zone, struct page *page)
-{
-	del_page_from_lru_list(zone, page, LRU_INACTIVE_ANON);
-}
-
-static inline void
-del_page_from_active_anon_list(struct zone *zone, struct page *page)
-{
-	del_page_from_lru_list(zone, page, LRU_ACTIVE_ANON);
-}
-
-static inline void
-del_page_from_inactive_file_list(struct zone *zone, struct page *page)
-{
-	del_page_from_lru_list(zone, page, LRU_INACTIVE_FILE);
-}
-
-static inline void
-del_page_from_active_file_list(struct zone *zone, struct page *page)
-{
-	del_page_from_lru_list(zone, page, LRU_INACTIVE_FILE);
-}
-
-static inline void
 del_page_from_lru(struct zone *zone, struct page *page)
 {
 	enum lru_list l = LRU_BASE;


