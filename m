Return-Path: <linux-kernel-owner+w=401wt.eu-S1765614AbXGQHvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765614AbXGQHvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758943AbXGQHtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:49:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51000 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbXGQHth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:49:37 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] um_kmalloc() remnants
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jdike@addtoit.com
Message-Id: <E1IAhoN-0001iw-Ul@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 17 Jul 2007 08:49:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/drivers/pcap_user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/drivers/pcap_user.c b/arch/um/drivers/pcap_user.c
index 483aa15..1316456 100644
--- a/arch/um/drivers/pcap_user.c
+++ b/arch/um/drivers/pcap_user.c
@@ -53,7 +53,7 @@ static int pcap_open(void *data)
 			return -EIO;
 		}
 
-		pri->compiled = um_kmalloc(sizeof(struct bpf_program));
+		pri->compiled = kmalloc(sizeof(struct bpf_program), UM_GFP_KERNEL);
 		if(pri->compiled == NULL){
 			printk(UM_KERN_ERR "pcap_open : kmalloc failed\n");
 			return -ENOMEM;
-- 
1.5.3.GIT


