Return-Path: <linux-kernel-owner+w=401wt.eu-S1761089AbYHFFnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761089AbYHFFnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 01:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYHFFne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 01:43:34 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:21123 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYHFFnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 01:43:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=tq94bchRjvTk1vh8UkIiQCccPLUhQEjbIL+AgNsphUbwA58xf0YvadQEANwTHvsUBK
         TmXTQYf3vW4D0CS+nemVNSnO7JHGW8M4TQoN2aaM4yvzWGeEqaZs4YaONEgI/Q/JLij6
         hqJjRDzbeu37y2y19ttC8BnB6MHQxr5NOrLyg=
From: MinChan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH][migration] Trivial cleanup
Date: Wed, 6 Aug 2008 14:42:54 +0900
User-Agent: KMail/1.9.9
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <20080805135559.GQ26461@parisc-linux.org> <20080805092209.830f5d0a.akpm@linux-foundation.org>
In-Reply-To: <20080805092209.830f5d0a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808061442.55159.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a trivial cleanup.
Anyone doesn't use it any more.  

Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
---
 mm/mempolicy.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 97020c0..36f4257 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -808,7 +808,6 @@ static int migrate_to_node(struct mm_struct *mm, int 
source, int dest,
 int do_migrate_pages(struct mm_struct *mm,
 	const nodemask_t *from_nodes, const nodemask_t *to_nodes, int flags)
 {
-	LIST_HEAD(pagelist);
 	int busy = 0;
 	int err = 0;
 	nodemask_t tmp;
-- 
1.5.4.3

