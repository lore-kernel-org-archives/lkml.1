Return-Path: <linux-kernel-owner+w=401wt.eu-S934540AbXGZQgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934540AbXGZQgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934364AbXGZQeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:34:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35332 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934180AbXGZQeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:34:10 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] viohs: extern on function definition
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
Message-Id: <E1IE6Hx-0005Fx-KN@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:34:09 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/sparc64/kernel/viohs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sparc64/kernel/viohs.c b/arch/sparc64/kernel/viohs.c
index 09126fc..708fa17 100644
--- a/arch/sparc64/kernel/viohs.c
+++ b/arch/sparc64/kernel/viohs.c
@@ -702,7 +702,7 @@ u32 vio_send_sid(struct vio_driver_state *vio)
 }
 EXPORT_SYMBOL(vio_send_sid);
 
-extern int vio_ldc_alloc(struct vio_driver_state *vio,
+int vio_ldc_alloc(struct vio_driver_state *vio,
 			 struct ldc_channel_config *base_cfg,
 			 void *event_arg)
 {
-- 
1.5.3.GIT


