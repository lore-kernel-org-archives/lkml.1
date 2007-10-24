Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbXJXQ2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbXJXQ2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757541AbXJXQXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:23:04 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33330 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757383AbXJXQXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:23:00 -0400
Date: Wed, 24 Oct 2007 18:23:29 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Eric Biederman <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/proc/proc_net.c: make a struct static
Message-ID: <20071024162329.GQ30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Struct proc_net_ns_ops can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
5ae49d45bc25eed356ecbe3592db270bfa1d9b73 
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index 2e91fb7..4edaad0 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -185,7 +185,7 @@ static __net_exit void proc_net_ns_exit(struct net *net)
 	kfree(net->proc_net_root);
 }
 
-struct pernet_operations __net_initdata proc_net_ns_ops = {
+static struct pernet_operations __net_initdata proc_net_ns_ops = {
 	.init = proc_net_ns_init,
 	.exit = proc_net_ns_exit,
 };

