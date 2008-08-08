Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbYHHU5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbYHHU5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 16:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbYHHU50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 16:57:26 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:36779 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbYHHU5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 16:57:25 -0400
Date: Fri, 8 Aug 2008 13:56:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] list.h: fix fatal kernel-doc error
Message-Id: <20080808135620.4f1522a5.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix fatal multi-line kernel-doc error in list.h:
function short description must be on one line.

Error(linux-2.6.27-rc2-git3//include/linux/list.h:318): duplicate section name 'Description'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/list.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.27-rc2-git3.orig/include/linux/list.h
+++ linux-2.6.27-rc2-git3/include/linux/list.h
@@ -309,11 +309,11 @@ static inline void list_splice_init(stru
 }
 
 /**
- * list_splice_tail_init - join two lists, each list being a queue, and
- *     reinitialise the emptied list.
+ * list_splice_tail_init - join two lists and reinitialise the emptied list
  * @list: the new list to add.
  * @head: the place to add it in the first list.
  *
+ * Each of the lists is a queue.
  * The list at @list is reinitialised
  */
 static inline void list_splice_tail_init(struct list_head *list,
