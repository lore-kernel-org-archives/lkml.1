Return-Path: <linux-kernel-owner+w=401wt.eu-S1762457AbXKTSf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762457AbXKTSf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761948AbXKTS1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:27:36 -0500
Received: from [198.99.130.12] ([198.99.130.12]:53264 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1761930AbXKTS1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:27:35 -0500
Date: Tue, 20 Nov 2007 13:26:33 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Joe Perches <joe@perches.com>
Subject: [PATCH 4/4] UML - add missing space
Message-ID: <20071120182633.GA7699@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Add missing space between merged string constants.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/vde_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22/arch/um/drivers/vde_user.c
===================================================================
--- linux-2.6.22.orig/arch/um/drivers/vde_user.c	2007-11-20 13:03:52.000000000 -0500
+++ linux-2.6.22/arch/um/drivers/vde_user.c	2007-11-20 13:09:46.000000000 -0500
@@ -80,7 +80,7 @@ void vde_init_libstuff(struct vde_data *
 
 	vpri->args = kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
 	if (vpri->args == NULL) {
-		printk(UM_KERN_ERR "vde_init_libstuff - vde_open_args"
+		printk(UM_KERN_ERR "vde_init_libstuff - vde_open_args "
 		       "allocation failed");
 		return;
 	}
