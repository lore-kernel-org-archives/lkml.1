Return-Path: <linux-kernel-owner+w=401wt.eu-S1750907Ab0AWFEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750907Ab0AWFEo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 00:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773Ab0AWFEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 00:04:44 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:44355 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab0AWFEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 00:04:43 -0500
X-Greylist: delayed 1576 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Jan 2010 00:04:43 EST
From: Himanshu Chauhan <himanshu@symmetricore.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: greg@kroah.com
Subject: [PATCH] usbip cleanup: Removing dead code
Date: Sat, 23 Jan 2010 10:36:56 +0530
Message-Id: <1264223216-27529-1-git-send-email-himanshu@symmetricore.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch removes the dead uncompiled code in usbip_common.c

Regards
Himanshu

Signed-off-by: Himanshu Chauhan <himanshu@symmetricore.com>
---
 drivers/staging/usbip/usbip_common.c |   54 ----------------------------------
 1 files changed, 0 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index 30fdf9d..564baae 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -532,60 +532,6 @@ err:
 }
 EXPORT_SYMBOL_GPL(usbip_xmit);
 
-
-/* now a usrland utility should set options. */
-#if 0
-int setquickack(struct socket *socket)
-{
-	mm_segment_t oldfs;
-	int val = 1;
-	int ret;
-
-	oldfs = get_fs();
-	set_fs(get_ds());
-	ret = socket->ops->setsockopt(socket, SOL_TCP, TCP_QUICKACK,
-			(char __user *) &val, sizeof(ret));
-	set_fs(oldfs);
-
-	return ret;
-}
-
-int setnodelay(struct socket *socket)
-{
-	mm_segment_t oldfs;
-	int val = 1;
-	int ret;
-
-	oldfs = get_fs();
-	set_fs(get_ds());
-	ret = socket->ops->setsockopt(socket, SOL_TCP, TCP_NODELAY,
-			(char __user *) &val, sizeof(ret));
-	set_fs(oldfs);
-
-	return ret;
-}
-
-int setkeepalive(struct socket *socket)
-{
-	mm_segment_t oldfs;
-	int val = 1;
-	int ret;
-
-	oldfs = get_fs();
-	set_fs(get_ds());
-	ret = socket->ops->setsockopt(socket, SOL_SOCKET, SO_KEEPALIVE,
-			(char __user *) &val, sizeof(ret));
-	set_fs(oldfs);
-
-	return ret;
-}
-
-void setreuse(struct socket *socket)
-{
-	socket->sk->sk_reuse = 1;
-}
-#endif
-
 struct socket *sockfd_to_socket(unsigned int sockfd)
 {
 	struct socket *socket;
-- 
1.6.3.3

