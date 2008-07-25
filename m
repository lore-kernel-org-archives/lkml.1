Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbYGYFNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbYGYFNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 01:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbYGYFNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 01:13:08 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:35998 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbYGYFNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 01:13:08 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH] drivers/net: Remove 'return' of void function NS8390p_init()
Date: Fri, 25 Jul 2008 02:13:02 -0300
Message-Id: <1216962782-32493-1-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need this into a void function.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 drivers/net/8390p.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/8390p.c b/drivers/net/8390p.c
index 71f1988..fd46f6c 100644
--- a/drivers/net/8390p.c
+++ b/drivers/net/8390p.c
@@ -39,7 +39,7 @@ struct net_device *__alloc_eip_netdev(int size)
 
 void NS8390p_init(struct net_device *dev, int startp)
 {
-	return __NS8390_init(dev, startp);
+	__NS8390_init(dev, startp);
 }
 
 EXPORT_SYMBOL(eip_open);
-- 
1.5.4.5

