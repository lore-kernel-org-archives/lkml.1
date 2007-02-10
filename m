Return-Path: <linux-kernel-owner+w=401wt.eu-S1752114AbXBJWpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbXBJWpx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 17:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbXBJWpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 17:45:53 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:43588 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbXBJWpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 17:45:52 -0500
Date: Sat, 10 Feb 2007 14:42:04 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@osdl.org>
Subject: [PATCH 3/3] IRQ kernel-doc fixes
Message-Id: <20070210144204.c9ee7a73.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in IRQ management.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/irq.h |    1 +
 kernel/irq/chip.c   |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.20-git6.orig/include/linux/irq.h
+++ linux-2.6.20-git6/include/linux/irq.h
@@ -127,6 +127,7 @@ struct irq_chip {
  *
  * @handle_irq:		highlevel irq-events handler [if NULL, __do_IRQ()]
  * @chip:		low level interrupt hardware access
+ * @msi_desc:		MSI descriptor
  * @handler_data:	per-IRQ data for the irq_chip methods
  * @chip_data:		platform-specific per-chip private data for the chip
  *			methods, to allow shared chip implementations
--- linux-2.6.20-git6.orig/kernel/irq/chip.c
+++ linux-2.6.20-git6/kernel/irq/chip.c
@@ -168,7 +168,7 @@ EXPORT_SYMBOL(set_irq_data);
 /**
  *	set_irq_data - set irq type data for an irq
  *	@irq:	Interrupt number
- *	@data:	Pointer to interrupt specific data
+ *	@entry:	Pointer to MSI descriptor data
  *
  *	Set the hardware irq controller data for an irq
  */
