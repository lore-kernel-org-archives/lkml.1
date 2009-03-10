Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbZCJFSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbZCJFSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbZCJFMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:12:08 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:28246 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbZCJFMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:12:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mOPnqAIf9OmcPJ/8oL3r1ipiffE/8yLh4fC/yol1PUd3qgwTKRoAG/Ka0kSZvZ1KKI
         WLWWjtY2n/1gi8rFER0sZGBMi0qFtoSp5T6GI11oegLwCWyKKcCX63VDB8MhOQz0o+0a
         tKrpayFmA3CVl0ZPvXwHnrbuN8GXxjIQUp8Mk=
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, dhowells@redhat.com,
       linux-afs@lists.infradead.org
Subject: [PATCH 21/25] [afs] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 00:10:46 -0500
Message-Id: <1236661850-8237-22-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236661850-8237-21-git-send-email-stoyboyker@gmail.com>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-5-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-6-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-7-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-8-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-9-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-10-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-11-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-12-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-13-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-14-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-15-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-16-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-17-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-18-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-19-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-20-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-21-git-send-email-stoyboyker@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
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
-- 
1.6.1.3

