Return-Path: <linux-kernel-owner+w=401wt.eu-S932087Ab0AMKhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab0AMKhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755740Ab0AMKhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:37:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:38535 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760Ab0AMKhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:37:50 -0500
Date: Wed, 13 Jan 2010 10:37:20 GMT
From: tip-bot for John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkacur@redhat.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkacur@redhat.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1263241267-25204-2-git-send-email-jkacur@redhat.com>
References: <1263241267-25204-2-git-send-email-jkacur@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] plist: Fix grammar mistake, and c-style mistake
Message-ID: <tip-9ca94d7c016130f9ed77f142424ace9c19742809@git.kernel.org>
Git-Commit-ID: 9ca94d7c016130f9ed77f142424ace9c19742809
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:37:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ca94d7c016130f9ed77f142424ace9c19742809
Gitweb:     http://git.kernel.org/tip/9ca94d7c016130f9ed77f142424ace9c19742809
Author:     John Kacur <jkacur@redhat.com>
AuthorDate: Mon, 11 Jan 2010 21:21:06 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 10:51:39 +0100

plist: Fix grammar mistake, and c-style mistake

Signed-off-by: John Kacur <jkacur@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1263241267-25204-2-git-send-email-jkacur@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/plist.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/plist.h b/include/linux/plist.h
index 8227f71..6898985 100644
--- a/include/linux/plist.h
+++ b/include/linux/plist.h
@@ -45,7 +45,7 @@
  * the insertion of new nodes. There are no nodes with duplicate
  * priorites on the list.
  *
- * The nodes on the node_list is ordered by priority and can contain
+ * The nodes on the node_list are ordered by priority and can contain
  * entries which have the same priority. Those entries are ordered
  * FIFO
  *
@@ -265,7 +265,7 @@ static inline int plist_node_empty(const struct plist_node *node)
  *
  * Assumes the plist is _not_ empty.
  */
-static inline struct plist_node* plist_first(const struct plist_head *head)
+static inline struct plist_node *plist_first(const struct plist_head *head)
 {
 	return list_entry(head->node_list.next,
 			  struct plist_node, plist.node_list);
