Return-Path: <linux-kernel-owner+w=401wt.eu-S1753749AbYAHXbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbYAHXbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756591AbYAHXal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:30:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:2248 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547AbYAHXak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:30:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=g61tQRrVm7GCN2SQRhkxJU14QzLJ66F/A2lwQIB+Bjtmw8LcXNL2lFo9i8dtcVWgkc+kZUDtplQRJdLaCpQ2600jzEgXaPBElnq1ujgDPwU5u9u1uUfkUBSAwKXDfjZGJzzvZUaezi61KnF2PI36irapudFhk3UnlTySRATSOvU=
Date: Wed, 9 Jan 2008 00:30:51 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] x86: coding style fixes in arch/x86/pci/acpi.c
Message-ID: <20080109003051.50611c19@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple coding style fixes.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/pci/acpi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 0234f28..c3c9cbf 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -142,7 +142,7 @@ adjust_transparent_bridge_resources(struct pci_bus *bus)
 		u16 class = dev->class >> 8;
 
 		if (class == PCI_CLASS_BRIDGE_PCI && dev->transparent) {
-			for(i = 3; i < PCI_BUS_NUM_RESOURCES; i++)
+			for (i = 3; i < PCI_BUS_NUM_RESOURCES; i++)
 				dev->subordinate->resource[i] =
 						dev->bus->resource[i - 3];
 		}
@@ -235,7 +235,7 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int do
 
 	if (bus && (pci_probe & PCI_USE__CRS))
 		get_current_resources(device, busnum, bus);
-	
+
 	return bus;
 }
 
-- 
1.5.4.rc2.17.g257f

