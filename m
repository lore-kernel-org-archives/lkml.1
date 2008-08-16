Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbYHPKJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbYHPKJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 06:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbYHPKI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 06:08:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:46012 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbYHPKI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 06:08:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lk9VdpPKOZAORr+a5xJ41vCs6ipH8sYAZ645YRtntrp+hABZ4wsoeAX8QDGHHFH8Ii
         D36GVVEfT0bZoVeTuHRZrvovfNx68cRYTJmf7zFUnwf+6eyowEDp+htoPrMdmfU9kD9k
         6t4oIbQJTa+zXlQOR87ePhJmoZlhNWUtXt3JY=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 3/5] x86: irq: interrupt array size should be NR_VECTORS
Date: Sat, 16 Aug 2008 03:07:27 -0700
Message-Id: <1218881249-3028-4-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218881249-3028-3-git-send-email-yhlu.kernel@gmail.com>
References: <1218881249-3028-1-git-send-email-yhlu.kernel@gmail.com>
 <1218881249-3028-2-git-send-email-yhlu.kernel@gmail.com>
 <1218881249-3028-3-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 drivers/pci/intr_remapping.c |    2 +-
 include/asm-x86/hw_irq.h     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/include/asm-x86/hw_irq.h
===================================================================
--- linux-2.6.orig/include/asm-x86/hw_irq.h
+++ linux-2.6/include/asm-x86/hw_irq.h
@@ -115,7 +115,7 @@ extern asmlinkage void smp_invalidate_in
 #endif
 
 #ifdef CONFIG_X86_32
-extern void (*const interrupt[NR_IRQS])(void);
+extern void (*const interrupt[NR_VECTORS])(void);
 #endif
 
 typedef int vector_irq_t[NR_VECTORS];
