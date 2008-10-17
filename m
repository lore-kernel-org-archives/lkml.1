Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbYJPLNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbYJPLNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 07:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbYJPLNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 07:13:04 -0400
Received: from ozlabs.org ([203.10.76.45]:46674 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756733AbYJPLND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:13:03 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu Oct 16 22:10:38 EST 2008
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/5] module: remove CONFIG_KMOD in comment after #endif
Message-Id: <20081016111214.717CDDDFB0@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/kmod.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -r da342255f684 kernel/kmod.c
--- a/kernel/kmod.c	Mon Aug 25 14:28:49 2008 +1000
+++ b/kernel/kmod.c	Mon Aug 25 14:31:44 2008 +1000
@@ -113,7 +113,7 @@ int request_module(const char *fmt, ...)
 	return ret;
 }
 EXPORT_SYMBOL(request_module);
-#endif /* CONFIG_KMOD */
+#endif /* CONFIG_MODULES */
 
 struct subprocess_info {
 	struct work_struct work;

