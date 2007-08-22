Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbXHVHXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbXHVHXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 03:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbXHVHXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 03:23:06 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:58168 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbXHVHXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 03:23:05 -0400
Subject: [PATCH] ppc: remove unused amiga_free_irq and mach_free_irq
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, galak@kernel.crashing.org
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 22 Aug 2007 16:23:02 +0900
Message-Id: <1187767382.25624.16.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

amiga_free_irq and mach_free_irq are never used, so delete them.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.23-rc3-orig/arch/ppc/amiga/config.c linux-2.6.23-rc3/arch/ppc/amiga/config.c
--- linux-2.6.23-rc3-orig/arch/ppc/amiga/config.c	2007-08-22 15:53:20.000000000 +0900
+++ linux-2.6.23-rc3/arch/ppc/amiga/config.c	2007-08-22 15:56:15.000000000 +0900
@@ -72,7 +72,6 @@ static void amiga_sched_init(irqreturn_t
 /* amiga specific irq functions */
 extern void amiga_init_IRQ (void);
 extern void (*amiga_default_handler[]) (int, void *, struct pt_regs *);
-extern void amiga_free_irq (unsigned int irq, void *dev_id);
 extern void amiga_enable_irq (unsigned int);
 extern void amiga_disable_irq (unsigned int);
 static void amiga_get_model(char *model);
@@ -378,7 +377,6 @@ void __init config_amiga(void)
   mach_init_IRQ        = amiga_init_IRQ;
 #ifndef CONFIG_APUS
   mach_default_handler = &amiga_default_handler;
-  mach_free_irq        = amiga_free_irq;
   enable_irq           = amiga_enable_irq;
   disable_irq          = amiga_disable_irq;
 #endif


