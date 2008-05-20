Return-Path: <linux-kernel-owner+w=401wt.eu-S1761792AbYETXmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761792AbYETXmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 19:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbYETXmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 19:42:06 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:9713 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbYETXmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 19:42:05 -0400
Date: Wed, 21 May 2008 01:42:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [PATCH] Fix incorrect comment in io_apic_64.c
Message-ID: <20080520234202.GA17536@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 20 May 2008 23:34:59.0548 (UTC) FILETIME=[1E5EB1C0:01C8BAD2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect comment in io_apic_64.c

No broadcasting happens.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/io_apic_64.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/arch/x86/kernel/io_apic_64.c
===================================================================
--- linux.orig/arch/x86/kernel/io_apic_64.c
+++ linux/arch/x86/kernel/io_apic_64.c
@@ -911,8 +911,7 @@ static void __init setup_IO_APIC_irqs(vo
 }
 
 /*
- * Set up the 8259A-master output pin as broadcast to all
- * CPUs.
+ * Set up the 8259A-master output pin to point to CPU 0.
  */
 static void __init setup_ExtINT_IRQ0_pin(unsigned int apic, unsigned int pin, int vector)
 {
