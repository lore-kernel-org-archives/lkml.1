Return-Path: <linux-kernel-owner+w=401wt.eu-S1761658AbZDIQMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761658AbZDIQMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 12:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756976AbZDIQLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 12:11:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37892 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757273AbZDIQLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 12:11:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Subject: [PATCH] [afs] BUG to BUG_ON changes
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Stoyan Gaydarov <stoyboyker@gmail.com>,
       David Howells <dhowells@redhat.com>
Date: Thu, 09 Apr 2009 17:10:28 +0100
Message-ID: <20090409161028.5196.63282.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stoyan Gaydarov <stoyboyker@gmail.com>

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/netdevices.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)


diff --git a/fs/afs/netdevices.c b/fs/afs/netdevices.c
index 49f1894..7ad3650 100644
--- a/fs/afs/netdevices.c
+++ b/fs/afs/netdevices.c
@@ -20,8 +20,7 @@ int afs_get_MAC_address(u8 *mac, size_t maclen)
 	struct net_device *dev;
 	int ret = -ENODEV;
 
-	if (maclen != ETH_ALEN)
-		BUG();
+	BUG_ON(maclen != ETH_ALEN);
 
 	rtnl_lock();
 	dev = __dev_getfirstbyhwtype(&init_net, ARPHRD_ETHER);

