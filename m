Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbXJWWhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbXJWWhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbXJWWgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:36:38 -0400
Received: from havoc.gtf.org ([69.61.125.42]:55448 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbXJWWgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:36:35 -0400
To: LKML <linux-kernel@vger.kernel.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, tglx@linutronix.de
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
Subject: [PATCH 2/12] X86: fix nvidia HPET warning
Message-Id: <20071023223635.24CE01F81A1@havoc.gtf.org>
Date: Tue, 23 Oct 2007 18:36:35 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/early-quirks.c:40: warning: ‘nvidia_hpet_check’ defined but not used

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index dc34acb..639e632 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -35,12 +35,14 @@ static void __init via_bugs(void)
 }
 
 #ifdef CONFIG_ACPI
+#ifdef CONFIG_X86_IO_APIC
 
 static int __init nvidia_hpet_check(struct acpi_table_header *header)
 {
 	return 0;
 }
-#endif
+#endif /* CONFIG_X86_IO_APIC */
+#endif /* CONFIG_ACPI */
 
 static void __init nvidia_bugs(void)
 {
