Return-Path: <linux-kernel-owner+w=401wt.eu-S1758971AbZABSPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971AbZABSPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757281AbZABSPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:15:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57114 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbZABSPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:15:36 -0500
Subject: [PATCH v2] x86: mpparse.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 02 Jan 2009 23:43:25 +0530
Message-Id: <1230920005.8976.7.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup, fix style problems, more readable

Fixes style problems:
WARNING: Use #include <linux/smp.h> instead of <asm/smp.h>
WARNING: Use #include <linux/acpi.h> instead of <asm/acpi.h>
WARNING: suspect code indent for conditional statements (8, 17)
WARNING: space prohibited between function name and open parenthesis '('

total: 0 errors, 5 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/mpparse.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 45e3b69..c5c5b8d 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -16,14 +16,14 @@
 #include <linux/bitops.h>
 #include <linux/acpi.h>
 #include <linux/module.h>
+#include <linux/smp.h>
+#include <linux/acpi.h>
 
-#include <asm/smp.h>
 #include <asm/mtrr.h>
 #include <asm/mpspec.h>
 #include <asm/pgalloc.h>
 #include <asm/io_apic.h>
 #include <asm/proto.h>
-#include <asm/acpi.h>
 #include <asm/bios_ebda.h>
 #include <asm/e820.h>
 #include <asm/trampoline.h>
@@ -95,8 +95,8 @@ static void __init MP_bus_info(struct mpc_config_bus *m)
 #endif
 
 	if (strncmp(str, BUSTYPE_ISA, sizeof(BUSTYPE_ISA) - 1) == 0) {
-		 set_bit(m->mpc_busid, mp_bus_not_pci);
-#if defined(CONFIG_EISA) || defined (CONFIG_MCA)
+		set_bit(m->mpc_busid, mp_bus_not_pci);
+#if defined(CONFIG_EISA) || defined(CONFIG_MCA)
 		mp_bus_id_to_type[m->mpc_busid] = MP_BUS_ISA;
 #endif
 	} else if (strncmp(str, BUSTYPE_PCI, sizeof(BUSTYPE_PCI) - 1) == 0) {
@@ -104,7 +104,7 @@ static void __init MP_bus_info(struct mpc_config_bus *m)
 			x86_quirks->mpc_oem_pci_bus(m);
 
 		clear_bit(m->mpc_busid, mp_bus_not_pci);
-#if defined(CONFIG_EISA) || defined (CONFIG_MCA)
+#if defined(CONFIG_EISA) || defined(CONFIG_MCA)
 		mp_bus_id_to_type[m->mpc_busid] = MP_BUS_PCI;
 	} else if (strncmp(str, BUSTYPE_EISA, sizeof(BUSTYPE_EISA) - 1) == 0) {
 		mp_bus_id_to_type[m->mpc_busid] = MP_BUS_EISA;
-- 
1.5.5.1



