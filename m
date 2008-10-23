Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbYJWUoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbYJWUoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 16:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbYJWUoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 16:44:12 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:11630 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbYJWUoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 16:44:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ulYEbwVOhtiAu03foScZFDwPKQvYJ1HbT/uHI2qsuEyv4LkQNK37sCKRrrsBnspPUX
         HX4I65YPjUSz+tx83G5hW+K/ikG/yaH37XkTxz18Kk3Nsho/Gm1K/0yIKnf3a4kajHRk
         7XCS222MU1pyvxs5CAroUvGG7O1FnU4wRKVak=
From: Dan McGee <dpmcgee@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, hpa@zytor.com, Dan McGee <dpmcgee@gmail.com>
Subject: [PATCH] Remove IRQBALANCE crud
Date: Thu, 23 Oct 2008 15:44:02 -0500
Message-Id: <1224794642-30350-1-git-send-email-dpmcgee@gmail.com>
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_IRQBALANCE was removed in commit 8b8e8c1bf; this ifdef was still
around.

Signed-off-by: Dan McGee <dpmcgee@gmail.com>
---
 arch/x86/include/asm/irq.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index bae0eda..28e409f 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -31,10 +31,6 @@ static inline int irq_canonicalize(int irq)
 # endif
 #endif
 
-#ifdef CONFIG_IRQBALANCE
-extern int irqbalance_disable(char *str);
-#endif
-
 #ifdef CONFIG_HOTPLUG_CPU
 #include <linux/cpumask.h>
 extern void fixup_irqs(cpumask_t map);
-- 
1.6.0.3

