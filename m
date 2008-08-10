Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbYHJNne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbYHJNne (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 09:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYHJNn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 09:43:27 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:14989 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbYHJNn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 09:43:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=kto3nAcOVYF/Y+0cWiuzpGlwoGn1nJOd2BUtnEPoL4poxpINYbJQXeP+AGT0WqyTPW
         Ny+kwg1vuu1wAHQYuIf9IkXlRtzF6/IoXBFMBDJ82SGyqsqbR/Fcw3lo18gX63/bK4Rl
         Inukb12dUW4s5w1p49AWxtpQpcCKlIyn3/Lww=
Date: Sun, 10 Aug 2008 15:42:52 +0200
To: Jeff Garzik <jgarzik@redhat.com>
Cc: Julia Lawall <julia@diku.dk>, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] au1000_eth: use 'unsigned long' for irqflags
Message-ID: <20080810134252.GA19751@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a0d915d5e99e752389093b3e1d6cae5ab5438392 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Wed, 6 Aug 2008 14:12:11 +0200
Subject: [PATCH] au1000_eth: use 'unsigned long' for irqflags

The patch was generated using the Coccinelle semantic patch framework.

Cc: Julia Lawall <julia@diku.dk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 drivers/net/au1000_eth.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/au1000_eth.c b/drivers/net/au1000_eth.c
index cb8be49..5ee1b05 100644
--- a/drivers/net/au1000_eth.c
+++ b/drivers/net/au1000_eth.c
@@ -807,7 +807,7 @@ err_out:
 static int au1000_init(struct net_device *dev)
 {
 	struct au1000_private *aup = (struct au1000_private *) dev->priv;
-	u32 flags;
+	unsigned long flags;
 	int i;
 	u32 control;
 
-- 
1.5.5.1

