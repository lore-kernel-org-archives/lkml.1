Return-Path: <linux-kernel-owner+w=401wt.eu-S1764359AbYEUAtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764359AbYEUAtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764533AbYEUAsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:48:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41609 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764345AbYEUAsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:48:13 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 1/6][uml] missed kmalloc() in pcap_user.c
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Message-Id: <E1JycV2-00063b-Js@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:48:12 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Jeff Dike <jdike@addtoit.com>
---
 arch/um/drivers/pcap_user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/drivers/pcap_user.c b/arch/um/drivers/pcap_user.c
index e980935..5f90358 100644
--- a/arch/um/drivers/pcap_user.c
+++ b/arch/um/drivers/pcap_user.c
@@ -50,7 +50,7 @@ static int pcap_open(void *data)
 			return -EIO;
 		}
 
-		pri->compiled = kmalloc(sizeof(struct bpf_program),
+		pri->compiled = uml_kmalloc(sizeof(struct bpf_program),
 					UM_GFP_KERNEL);
 		if (pri->compiled == NULL) {
 			printk(UM_KERN_ERR "pcap_open : kmalloc failed\n");
-- 
1.5.3.GIT


