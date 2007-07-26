Return-Path: <linux-kernel-owner+w=401wt.eu-S934854AbXGZQkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934854AbXGZQkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934445AbXGZQfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:35:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43060 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934369AbXGZQfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:35:22 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] cxgb3 gfp_t annotations
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com
Message-Id: <E1IE6J5-0005Mn-NU@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:35:19 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/cxgb3/cxgb3_offload.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/cxgb3/cxgb3_offload.c b/drivers/net/cxgb3/cxgb3_offload.c
index ebcf35e..e620ed4 100644
--- a/drivers/net/cxgb3/cxgb3_offload.c
+++ b/drivers/net/cxgb3/cxgb3_offload.c
@@ -699,7 +699,7 @@ static int do_cr(struct t3cdev *dev, struct sk_buff *skb)
  * the buffer.
  */
 static struct sk_buff *cxgb3_get_cpl_reply_skb(struct sk_buff *skb, size_t len,
-					       int gfp)
+					       gfp_t gfp)
 {
 	if (likely(!skb_cloned(skb))) {
 		BUG_ON(skb->len < len);
-- 
1.5.3.GIT


