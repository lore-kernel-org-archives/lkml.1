Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbZKQWxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbZKQWxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756631AbZKQWwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:52:04 -0500
Received: from www.tglx.de ([62.245.132.106]:41633 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756671AbZKQWwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:52:00 -0500
Message-Id: <20091117224916.370134079@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 17 Nov 2009 22:50:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Subject: [patch 01/13] x86: Fixup last users of irq_chip->typename 
References: <20091117224852.846805939@linutronix.de>
Content-Disposition: inline; filename=x86-replace-obsolete-typename.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The typename member of struct irq_chip was kept for migration purposes
and is obsolete since more than 2 years. Fix up the leftovers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/visws_quirks.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/visws_quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/visws_quirks.c
+++ linux-2.6/arch/x86/kernel/visws_quirks.c
@@ -486,7 +486,7 @@ static void end_cobalt_irq(unsigned int 
 }
 
 static struct irq_chip cobalt_irq_type = {
-	.typename =	"Cobalt-APIC",
+	.name =		"Cobalt-APIC",
 	.startup =	startup_cobalt_irq,
 	.shutdown =	disable_cobalt_irq,
 	.enable =	enable_cobalt_irq,
@@ -523,7 +523,7 @@ static void end_piix4_master_irq(unsigne
 }
 
 static struct irq_chip piix4_master_irq_type = {
-	.typename =	"PIIX4-master",
+	.name =		"PIIX4-master",
 	.startup =	startup_piix4_master_irq,
 	.ack =		ack_cobalt_irq,
 	.end =		end_piix4_master_irq,
@@ -531,7 +531,7 @@ static struct irq_chip piix4_master_irq_
 
 
 static struct irq_chip piix4_virtual_irq_type = {
-	.typename =	"PIIX4-virtual",
+	.name =		"PIIX4-virtual",
 	.shutdown =	disable_8259A_irq,
 	.enable =	enable_8259A_irq,
 	.disable =	disable_8259A_irq,


