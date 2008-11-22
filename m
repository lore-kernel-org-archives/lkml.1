Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbYKVBA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbYKVBA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 20:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbYKVBAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 20:00:20 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:51527 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbYKVBAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 20:00:19 -0500
Message-ID: <4927598D.3090505@oracle.com>
Date: Fri, 21 Nov 2008 16:59:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] irq.h: fix missing/extra kernel-doc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.49275990.0129:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix missing & excess irq.h kernel-doc:

Warning(include/linux/irq.h:182): No description found for parameter 'irq'
Warning(include/linux/irq.h:182): Excess struct/union/enum/typedef member 'affinity_entry' description in 'irq_desc'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/irq.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.28-rc6-git1.orig/include/linux/irq.h
+++ linux-2.6.28-rc6-git1/include/linux/irq.h
@@ -130,7 +130,7 @@ struct irq_chip {
 
 /**
  * struct irq_desc - interrupt descriptor
- *
+ * @irq:		interrupt number for this descriptor
  * @handle_irq:		highlevel irq-events handler [if NULL, __do_IRQ()]
  * @chip:		low level interrupt hardware access
  * @msi_desc:		MSI descriptor
@@ -149,7 +149,6 @@ struct irq_chip {
  * @cpu:		cpu index useful for balancing
  * @pending_mask:	pending rebalanced interrupts
  * @dir:		/proc/irq/ procfs entry
- * @affinity_entry:	/proc/irq/smp_affinity procfs entry on SMP
  * @name:		flow handler name for /proc/interrupts output
  */
 struct irq_desc {
