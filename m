Return-Path: <linux-kernel-owner+w=401wt.eu-S1762755AbYCCT3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762755AbYCCT3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbYCCT3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:29:47 -0500
Received: from gv-out-0910.google.com ([216.239.58.191]:59080 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbYCCT3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:29:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dX0ZooOG35U+YUNTzE586RKej7Lk1nXRceyZdsN5bXxJOU9e06WgbPJLoR8Ws6zisEt+FBBmyKat5Oj19IXWGPISznGcXQkdqkQl2c/mHlVNMmvbdYK+aZ2bDmyl0IbZcUBsAjLKj4NRw+MlK1pOA3tDLVR5KJdhd4E2Ck3o8ig=
Subject: [PATCH] xtensa: replace remaining __FUNCTION__ occurance
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 11:29:41 -0800
Message-Id: <1204572581.3266.46.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/xtensa/kernel/irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/xtensa/kernel/irq.c b/arch/xtensa/kernel/irq.c
index c9ea73b..5fbcde5 100644
--- a/arch/xtensa/kernel/irq.c
+++ b/arch/xtensa/kernel/irq.c
@@ -48,7 +48,7 @@ asmlinkage void do_IRQ(int irq, struct pt_regs *regs)
 
 	if (irq >= NR_IRQS) {
 		printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
-				__FUNCTION__, irq);
+				__func__, irq);
 	}
 
 	irq_enter();
-- 
1.5.4.3.500.g83a2c



