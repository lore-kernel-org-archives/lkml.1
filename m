Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbXKTBwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbXKTBwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757310AbXKTBtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:49:07 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2052 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847AbXKTBs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:48:56 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jeff Dike <jdike@addtoit.com>, user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 08/59] arch/um: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:00 -0800
Message-Id: <1195523331-15303-9-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-8-git-send-email-joe@perches.com>
References: 1234567
 <1195523331-15303-1-git-send-email-joe@perches.com>
 <1195523331-15303-2-git-send-email-joe@perches.com>
 <1195523331-15303-3-git-send-email-joe@perches.com>
 <1195523331-15303-4-git-send-email-joe@perches.com>
 <1195523331-15303-5-git-send-email-joe@perches.com>
 <1195523331-15303-6-git-send-email-joe@perches.com>
 <1195523331-15303-7-git-send-email-joe@perches.com>
 <1195523331-15303-8-git-send-email-joe@perches.com>
Message-Id: <fbeb04f6d7134565611741ad0148e1b401362ef9.1195454434.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/um/drivers/vde_user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/drivers/vde_user.c b/arch/um/drivers/vde_user.c
index d9941fe..56533db 100644
--- a/arch/um/drivers/vde_user.c
+++ b/arch/um/drivers/vde_user.c
@@ -80,7 +80,7 @@ void vde_init_libstuff(struct vde_data *vpri, struct vde_init *init)
 
 	vpri->args = kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
 	if (vpri->args == NULL) {
-		printk(UM_KERN_ERR "vde_init_libstuff - vde_open_args"
+		printk(UM_KERN_ERR "vde_init_libstuff - vde_open_args "
 		       "allocation failed");
 		return;
 	}
-- 
1.5.3.5.652.gf192c

