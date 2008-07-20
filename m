Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbYGTPvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbYGTPvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 11:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757371AbYGTPvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 11:51:31 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:50151 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360AbYGTPvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 11:51:31 -0400
From: Emil Medve <Emilian.Medve@Freescale.com>
To: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-smp@vger.kernel.org
Cc: Emil Medve <Emilian.Medve@Freescale.com>
Subject: [PATCH] Export irq_set_affinity()
Date: Sun, 20 Jul 2008 10:46:19 -0500
Message-Id: <1216568779-11828-1-git-send-email-Emilian.Medve@Freescale.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
---

This is needed for drivers built as modules and running on SMP systems that want
to set initial/default explicit IRQ balancing

$ scripts/checkpatch.pl 0001-Export-irq_set_affinity.patch 
total: 0 errors, 0 warnings, 7 lines checked

0001-Export-irq_set_affinity.patch has no obvious style problems and is ready for submission.

 kernel/irq/manage.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 77a51be..29c5b5a 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -96,6 +96,7 @@ int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
 #endif
 	return 0;
 }
+EXPORT_SYMBOL(irq_set_affinity);
 
 #ifndef CONFIG_AUTO_IRQ_AFFINITY
 /*
-- 
1.5.6.3

