Return-Path: <linux-kernel-owner+w=401wt.eu-S1761881AbXLMKcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761881AbXLMKcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 05:32:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761336AbXLMKby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 05:31:54 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:35548
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761497AbXLMKbx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 05:31:53 -0500
Message-Id: <47611859.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 13 Dec 2007 10:32:41 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: adjust make conditions CONFIG_PM ->
	CONFIG_PM_SLEEP
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two files in question are unused without CONFIG_PM_SLEEP.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/x86/kernel/Makefile_64 |    2 +-
 arch/x86/power/Makefile     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.24-rc5/arch/x86/kernel/Makefile_64	2007-12-12 11:28:17.000000000 +0100
+++ 2.6.24-rc5-x86-pm-sleep/arch/x86/kernel/Makefile_64	2007-12-04 16:09:33.000000000 +0100
@@ -24,7 +24,7 @@ obj-y				+= apic_64.o  nmi_64.o
 obj-y				+= io_apic_64.o mpparse_64.o genapic_64.o genapic_flat_64.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_64.o relocate_kernel_64.o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_64.o
-obj-$(CONFIG_PM)		+= suspend_64.o
+obj-$(CONFIG_PM_SLEEP)		+= suspend_64.o
 obj-$(CONFIG_HIBERNATION)	+= suspend_asm_64.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_GART_IOMMU)	+= pci-gart_64.o aperture_64.o
--- linux-2.6.24-rc5/arch/x86/power/Makefile	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-x86-pm-sleep/arch/x86/power/Makefile	2007-12-04 16:09:33.000000000 +0100
@@ -1,2 +1,2 @@
-obj-$(CONFIG_PM)		+= cpu.o
+obj-$(CONFIG_PM_SLEEP)		+= cpu.o
 obj-$(CONFIG_HIBERNATION)	+= swsusp.o suspend.o



