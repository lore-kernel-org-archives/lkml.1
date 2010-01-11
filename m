Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321Ab0AKUVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab0AKUVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293Ab0AKUVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:21:18 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:47909 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab0AKUVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:21:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=pm4ow8dw6n01a91v1G1A72U+uplV3ebc2WASs2gKe2xRxWXSdmzv8tQ4lxyr0KmBfW
         ncvRTw6ZrhWXXLgVPS+EggAXbiZNtW9Uxjb+eP8x4vMqZdqK3jcl022u1RtCyHJpQKl2
         /jDRFLML6Xb0h0VGKUWrrVHvRGIp0QvraKZ18=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: John Kacur <jkacur@redhat.com>
Subject: [PATCH 1/2] plist: Fix grammar mistake, and c-style mistake.
Date: Mon, 11 Jan 2010 21:21:06 +0100
Message-Id: <1263241267-25204-2-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263241267-25204-1-git-send-email-jkacur@redhat.com>
References: <1263241267-25204-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: John Kacur <jkacur@redhat.com>
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
-- 
1.6.5.2

