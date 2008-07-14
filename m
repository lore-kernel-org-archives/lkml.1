Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115AbYGNQSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbYGNQSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYGNQSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:18:40 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62842 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753206AbYGNQSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:18:39 -0400
Date: Mon, 14 Jul 2008 17:18:04 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: I/O APIC: Include <asm/i8259.h> required by some code
Message-ID: <Pine.LNX.4.55.0807141709300.16334@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Include <asm/i8259.h> for i8259A_lock used in print_PIC() -- #if-0-ed out
by default.  The 32-bit version gets it right already.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 The plan is to enable this code with "apic=debug" eventually.  This will
aid with debugging strange problems without the need to ask people to
apply patches.

  Maciej

patch-next-2.6.26-rc9-20080711-apic-pic-i8259-h-0
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_64.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_64.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_64.c	2008-07-14 15:44:12.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_64.c	2008-07-14 15:47:19.000000000 +0000
@@ -45,6 +45,7 @@
 #include <asm/proto.h>
 #include <asm/acpi.h>
 #include <asm/dma.h>
+#include <asm/i8259.h>
 #include <asm/nmi.h>
 #include <asm/msidef.h>
 #include <asm/hypertransport.h>
