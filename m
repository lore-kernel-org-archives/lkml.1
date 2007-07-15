Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbXGOUAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbXGOUAa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 16:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbXGOT7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 15:59:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39909 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545AbXGOT7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 15:59:42 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] the wrong variable checked after request_irq()
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Message-Id: <E1IAAFp-00053g-Ti@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 15 Jul 2007 20:59:41 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/powerpc/platforms/pseries/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 470db6e..a031d99 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -176,7 +176,7 @@ static void __init pseries_mpic_init_IRQ(void)
 		return;
 
 	cascade_irq = irq_of_parse_and_map(cascade, 0);
-	if (cascade == NO_IRQ) {
+	if (cascade_irq == NO_IRQ) {
 		printk(KERN_ERR "mpic: failed to map cascade interrupt");
 		return;
 	}
-- 
1.5.3.GIT


