Return-Path: <linux-kernel-owner+w=401wt.eu-S1760856AbZCZUsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760856AbZCZUsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756790AbZCZUsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:48:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33486 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756789AbZCZUsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:48:01 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] appletalk: this warning can go I think
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 26 Mar 2009 20:49:02 +0000
Message-ID: <20090326204858.4910.28079.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its past 2.2 ...

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk?>
---

 net/appletalk/ddp.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)


diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 5abce07..3104be8 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1571,14 +1571,10 @@ static int atalk_sendmsg(struct kiocb *iocb, struct socket *sock, struct msghdr
 		    usat->sat_family != AF_APPLETALK)
 			return -EINVAL;
 
-		/* netatalk doesn't implement this check */
+		/* netatalk didn't implement this check */
 		if (usat->sat_addr.s_node == ATADDR_BCAST &&
 		    !sock_flag(sk, SOCK_BROADCAST)) {
-			printk(KERN_INFO "SO_BROADCAST: Fix your netatalk as "
-					 "it will break before 2.2\n");
-#if 0
 			return -EPERM;
-#endif
 		}
 	} else {
 		if (sk->sk_state != TCP_ESTABLISHED)

