Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbZFEOat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbZFEOat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZFEOam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:30:42 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:45365 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZFEOam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:30:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pwM5/00iTn7NkC7rY6Lb50sLyPwDlBXfUJXCfrhov/q+KhnJHFswMtobbIx1gAGr+C
         bU9HQ8WLg+WaI9NKC7RcxycJRlz/2btn663SPv0uBhHi83s++VGzGxp+M6lg/wsa+07e
         eGwSTMtBopsGOgYvKBi1hDQBAk+V+yM1PpXpA=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Minchan Kim <minchan.kim@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: [PATCH][mmtom] remove annotation of gfp_mask in add_to_swap
Date: Fri,  5 Jun 2009 23:30:35 +0900
Message-Id: <1244212237-14128-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh removed add_to_swap's gfp_mask argument.
(mm: remove gfp_mask from add_to_swap)
So we have to remove annotation of gfp_mask  of the function.

This patch cleans up add_to_swap function.
It doesn't affect behavior of function.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---
 mm/swap_state.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index b9ca029..b62e7f5 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -124,7 +124,6 @@ void __delete_from_swap_cache(struct page *page)
 /**
  * add_to_swap - allocate swap space for a page
  * @page: page we want to move to swap
- * @gfp_mask: memory allocation flags
  *
  * Allocate swap space for the page and add the page to the
  * swap cache.  Caller needs to hold the page lock. 
-- 
1.5.6.5

