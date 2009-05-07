Return-Path: <linux-kernel-owner+w=401wt.eu-S1761906AbZEHAMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761906AbZEHAMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756502AbZEHAJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:09:59 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52705
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753723AbZEHAJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:09:54 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 17/18] xen/apic: checkpatch cleanups
Date: Thu,  7 May 2009 14:14:42 -0700
Message-Id: <1241730883-4917-18-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241730883-4917-1-git-send-email-jeremy@goop.org>
References: <1241730883-4917-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Clean up mostly whitespace issues.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/apic.c  |    4 ++--
 arch/x86/xen/pci.c   |    4 ++--
 drivers/xen/events.c |    7 ++++---
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
index 3f890c4..496f07d 100644
--- a/arch/x86/xen/apic.c
+++ b/arch/x86/xen/apic.c
@@ -53,8 +53,8 @@ void xen_init_apic(void)
 #ifdef CONFIG_ACPI
 	/*
 	 * Pretend ACPI found our lapic even though we've disabled it,
- 	 * to prevent MP tables from setting up lapics.
- 	 */
+	 * to prevent MP tables from setting up lapics.
+	 */
 	acpi_lapic = 1;
 #endif
 }
diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index 69b475b..5b9ee11 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -66,13 +66,13 @@ void __init xen_setup_pirqs(void)
 	int irq;
 
 	if (0 == nr_ioapics) {
-		for (irq=0; irq < NR_IRQS_LEGACY; irq++)
+		for (irq = 0; irq < NR_IRQS_LEGACY; irq++)
 			xen_allocate_pirq(irq, "xt-pic");
 		return;
 	}
 
 	/* Pre-allocate legacy irqs */
-	for (irq=0; irq < NR_IRQS_LEGACY; irq++) {
+	for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
 		int trigger, polarity;
 
 		if (acpi_get_override_irq(irq, &trigger, &polarity) == -1)
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index b8fd514..febab09 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -514,7 +514,7 @@ static int find_irq_by_gsi(unsigned gsi)
 {
 	int irq;
 
-	for(irq = 0; irq < nr_irqs; irq++) {
+	for (irq = 0; irq < nr_irqs; irq++) {
 		struct irq_info *info = info_for_irq(irq);
 
 		if (info == NULL || info->type != IRQT_PIRQ)
@@ -1181,8 +1181,9 @@ void __init xen_init_IRQ(void)
 	cpu_evtchn_mask_p = alloc_bootmem(size);
 	irq_info = alloc_bootmem(nr_irqs * sizeof(*irq_info));
 
-	evtchn_to_irq = alloc_bootmem(NR_EVENT_CHANNELS * sizeof(*evtchn_to_irq));
-	for(i = 0; i < NR_EVENT_CHANNELS; i++)
+	evtchn_to_irq = alloc_bootmem(NR_EVENT_CHANNELS *
+				      sizeof(*evtchn_to_irq));
+	for (i = 0; i < NR_EVENT_CHANNELS; i++)
 		evtchn_to_irq[i] = -1;
 
 	init_evtchn_cpu_bindings();
-- 
1.6.0.6

