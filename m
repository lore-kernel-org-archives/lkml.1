Return-Path: <linux-kernel-owner+w=401wt.eu-S932107AbXBJMD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbXBJMD0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 07:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932095AbXBJMDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 07:03:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:55770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933329AbXBJLu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:50:28 -0500
From: Andi Kleen <ak@suse.de>
References: <200702101250.142420000@suse.de>
In-Reply-To: <200702101250.142420000@suse.de>
To: "Maciej W. Rozycki" <macro@linux-mips.org>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21 review I] [13/25] i386: Fix a typo in an IRQ handler name
Message-Id: <20070210115025.ED8CF13E10@wotan.suse.de>
Date: Sat, 10 Feb 2007 12:50:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Maciej W. Rozycki" <macro@linux-mips.org>

The "fasteoi" IRQ handler is named "fasteio" incorrectly.  This is a fix.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/io_apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/kernel/io_apic.c
===================================================================
--- linux.orig/arch/i386/kernel/io_apic.c
+++ linux/arch/i386/kernel/io_apic.c
@@ -2310,7 +2310,7 @@ static inline void __init check_timer(vo
 
 	disable_8259A_irq(0);
 	set_irq_chip_and_handler_name(0, &lapic_chip, handle_fasteoi_irq,
-				      "fasteio");
+				      "fasteoi");
 	apic_write_around(APIC_LVT0, APIC_DM_FIXED | vector);	/* Fixed mode */
 	enable_8259A_irq(0);
 
