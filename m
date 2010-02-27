Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968336Ab0B0NjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 08:39:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54302 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968286Ab0B0NjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 08:39:17 -0500
Date: Sat, 27 Feb 2010 14:38:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] core/locking changes for v2.6.34
Message-ID: <20100227133858.GA32272@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-locking-for-linus

Lockdep was very quiet in this cycle - a single cleanup.

 Thanks,

	Ingo

------------------>
John Kacur (1):
      plist: Fix grammar mistake, and c-style mistake


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
