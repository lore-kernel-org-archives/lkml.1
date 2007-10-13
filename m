Return-Path: <linux-kernel-owner+w=401wt.eu-S1760281AbXJMCeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281AbXJMCeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 22:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbXJMCem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 22:34:42 -0400
Received: from havoc.gtf.org ([69.61.125.42]:44401 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbXJMCel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 22:34:41 -0400
Date: Fri, 12 Oct 2007 22:34:40 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/pci/acpi: fix DMI const-ification fallout
Message-ID: <20071013023440.GA20186@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix DMI const-ification fallout that appeared when merging subsystem
trees.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 arch/x86/pci/acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 27a391d..2d88f7c 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -6,7 +6,7 @@
 #include <asm/numa.h>
 #include "pci.h"
 
-static int __devinit can_skip_ioresource_align(struct dmi_system_id *d)
+static int __devinit can_skip_ioresource_align(const struct dmi_system_id *d)
 {
 	pci_probe |= PCI_CAN_SKIP_ISA_ALIGN;
 	printk(KERN_INFO "PCI: %s detected, can skip ISA alignment\n", d->ident);
