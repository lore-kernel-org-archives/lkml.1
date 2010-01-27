Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943Ab0A0SNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab0A0SNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 13:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249Ab0A0SNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 13:13:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:42359 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab0A0SNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 13:13:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=Fmt5YqOi7AqxbZKaCrdDCYkDYtoAkZFtVW9iARuej7V4NuBjYfs469gIiJe3CT3Ru/
         b13zvgkA0nDpgc9qiqd2UJSaGo9omhxWkmd7Qu3x3AkHneWe5TYSXDwt8vqx+VAvnMvJ
         34c/uO5jJRsLPmnKhknHFEcYcULSVpNqafStM=
From: Don Mullis <don.mullis@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: airlied@redhat.com, andi@firstfloor.org, david@fromorbit.com,
       dedekind@infradead.org
Subject: [PATCH v2 2/3] lib: Revise list_sort() header comment
References: <878wbja0h6.fsf@gmail.com>
Date: Wed, 27 Jan 2010 10:13:12 -0800
In-Reply-To: <878wbja0h6.fsf@gmail.com> (Don Mullis's message of "Wed, 27 Jan
	2010 10:04:05 -0800")
Message-ID: <874om7a01z.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clarify and correct header comment of list_sort().

Signed-off-by: Don Mullis <don.mullis@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>
---
 lib/list_sort.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

Index: linux-2.6/lib/list_sort.c
===================================================================
--- linux-2.6.orig/lib/list_sort.c	2010-01-26 20:01:55.000000000 -0800
+++ linux-2.6/lib/list_sort.c	2010-01-26 20:05:11.000000000 -0800
@@ -81,17 +81,18 @@ static void merge_and_restore_back_links
 }
 
 /**
- * list_sort - sort a list.
- * @priv: private data, passed to @cmp
+ * list_sort - sort a list
+ * @priv: private data, opaque to list_sort(), passed to @cmp
  * @head: the list to sort
  * @cmp: the elements comparison function
  *
- * This function implements "merge sort" which has O(nlog(n)) complexity.
- * The list is sorted in ascending order.
+ * This function implements "merge sort", which has O(nlog(n))
+ * complexity.
  *
- * The comparison function @cmp is supposed to return a negative value if @a is
- * less than @b, and a positive value if @a is greater than @b. If @a and @b
- * are equivalent, then it does not matter what this function returns.
+ * The comparison function @cmp must return a negative value if @a
+ * should sort before @b, and a positive value if @a should sort after
+ * @b. If @a and @b are equivalent, and their original relative
+ * ordering is to be preserved, @cmp must return 0.
  */
 void list_sort(void *priv, struct list_head *head,
 		int (*cmp)(void *priv, struct list_head *a,
