Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbYAHXar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbYAHXar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbYAHXad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:30:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:2248 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbYAHXab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:30:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=pGHjfn0izJ3tJKFXJd6mkBdnjJ0cHRXlh+xnzIVcmIegWw8/qKjDoUiFPxEat1DDtU2+gPfTunFDi6nKhGrnn2wMPqG8rUbUIub606tQ7fRknAxv7d78llTyNKV4j4sQoumMb8FQKwwDUng3mW94aEEmHRZOVKKnA/Iako8LSfE=
Date: Wed, 9 Jan 2008 00:30:42 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] x86: coding style fixes in /arch/x86/pci/common.c
Message-ID: <20080109003042.7c38d706@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some coding style issues.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/pci/common.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 52deabc..7388b1a 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -67,7 +67,7 @@ static void __devinit pcibios_fixup_ghosts(struct pci_bus *b)
 {
 	struct list_head *ln, *mn;
 	struct pci_dev *d, *e;
-	int mirror = PCI_DEVFN(16,0);
+	int mirror = PCI_DEVFN(16, 0);
 	int seen_host_bridge = 0;
 	int i;
 
@@ -76,14 +76,14 @@ static void __devinit pcibios_fixup_ghosts(struct pci_bus *b)
 		d = pci_dev_b(ln);
 		if ((d->class >> 8) == PCI_CLASS_BRIDGE_HOST)
 			seen_host_bridge++;
-		for (mn=ln->next; mn != &b->devices; mn=mn->next) {
+		for (mn = ln->next; mn != &b->devices; mn = mn->next) {
 			e = pci_dev_b(mn);
 			if (e->devfn != d->devfn + mirror ||
 			    e->vendor != d->vendor ||
 			    e->device != d->device ||
 			    e->class != d->class)
 				continue;
-			for(i=0; i<PCI_NUM_RESOURCES; i++)
+			for (i = 0; i < PCI_NUM_RESOURCES; i++)
 				if (e->resource[i].start != d->resource[i].start ||
 				    e->resource[i].end != d->resource[i].end ||
 				    e->resource[i].flags != d->resource[i].flags)
@@ -449,8 +449,7 @@ char * __devinit  pcibios_setup(char *str)
 	else if (!strcmp(str, "conf1")) {
 		pci_probe = PCI_PROBE_CONF1 | PCI_NO_CHECKS;
 		return NULL;
-	}
-	else if (!strcmp(str, "conf2")) {
+	} else if (!strcmp(str, "conf2")) {
 		pci_probe = PCI_PROBE_CONF2 | PCI_NO_CHECKS;
 		return NULL;
 	}
@@ -464,8 +463,7 @@ char * __devinit  pcibios_setup(char *str)
 	else if (!strcmp(str, "noacpi")) {
 		acpi_noirq_set();
 		return NULL;
-	}
-	else if (!strcmp(str, "noearly")) {
+	} else if (!strcmp(str, "noearly")) {
 		pci_probe |= PCI_PROBE_NOEARLY;
 		return NULL;
 	}
-- 
1.5.4.rc2.17.g257f

