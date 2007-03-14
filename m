Return-Path: <linux-kernel-owner+w=401wt.eu-S1030784AbXCNJTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030784AbXCNJTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030740AbXCNJTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:19:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60496 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030803AbXCNJTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:19:20 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 9/17] qeth gfp_t annotations
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HRPdg-0003Uu-1J@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:19:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/s390/net/qeth.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/s390/net/qeth.h b/drivers/s390/net/qeth.h
index e95c281..84b108d 100644
--- a/drivers/s390/net/qeth.h
+++ b/drivers/s390/net/qeth.h
@@ -873,7 +873,7 @@ qeth_realloc_headroom(struct qeth_card *card, struct sk_buff *skb, int size)
 }
 
 static inline struct sk_buff *
-qeth_pskb_unshare(struct sk_buff *skb, int pri)
+qeth_pskb_unshare(struct sk_buff *skb, gfp_t pri)
 {
         struct sk_buff *nskb;
         if (!skb_cloned(skb))
-- 
1.5.0-rc2.GIT


