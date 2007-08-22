Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbXHVASN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbXHVASN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 20:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbXHVAR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 20:17:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:58606 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbXHVAR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 20:17:57 -0400
Date: Tue, 21 Aug 2007 19:18:00 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: Linus Torvalds <torvalds@osdl.org>
cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Please pull from 'fixes-2.6.23' branch
Message-ID: <Pine.LNX.4.64.0708211917250.14411@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'fixes-2.6.23' branch of

	master.kernel.org:/pub/scm/linux/kernel/git/galak/powerpc.git fixes-2.6.23

to receive the following updates:

 arch/powerpc/sysdev/fsl_pci.c |    2 ++
 include/linux/pci_ids.h       |    6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

Kumar Gala (1):
      [POWERPC] Fix PCI Device ID for MPC8544/8533 processors

commit 15f6ddc7d9cf96f2ee88897c7164198ed6e45a77
Author: Kumar Gala <galak@kernel.crashing.org>
Date:   Tue Aug 21 19:15:31 2007 -0500

    [POWERPC] Fix PCI Device ID for MPC8544/8533 processors

    The initial user manuals for MPC8544/8533 had some issues with properly
    documenting the device IDs for MPC8544/8533.  These processors are almost
    identical and both show up on the reference boards.

    Fix up the quirks for PCIe support to handle MPC8533/E.

    Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index 9fb0ce5..114c90f 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -251,6 +251,8 @@ DECLARE_PCI_FIXUP_EARLY(0x1957, PCI_DEVICE_ID_MPC8568E, quirk_fsl_pcie_transpare
 DECLARE_PCI_FIXUP_EARLY(0x1957, PCI_DEVICE_ID_MPC8568, quirk_fsl_pcie_transparent);
 DECLARE_PCI_FIXUP_EARLY(0x1957, PCI_DEVICE_ID_MPC8567E, quirk_fsl_pcie_transparent);
 DECLARE_PCI_FIXUP_EARLY(0x1957, PCI_DEVICE_ID_MPC8567, quirk_fsl_pcie_transparent);
+DECLARE_PCI_FIXUP_EARLY(0x1957, PCI_DEVICE_ID_MPC8533E, quirk_fsl_pcie_transparent);
+DECLARE_PCI_FIXUP_EARLY(0x1957, PCI_DEVICE_ID_MPC8533, quirk_fsl_pcie_transparent);
 DECLARE_PCI_FIXUP_EARLY(0x1957, PCI_DEVICE_ID_MPC8544E, quirk_fsl_pcie_transparent);
 DECLARE_PCI_FIXUP_EARLY(0x1957, PCI_DEVICE_ID_MPC8544, quirk_fsl_pcie_transparent);
 DECLARE_PCI_FIXUP_EARLY(0x1957, PCI_DEVICE_ID_MPC8641, quirk_fsl_pcie_transparent);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 07fc574..8938d59 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2092,8 +2092,10 @@
 #define PCI_DEVICE_ID_MPC8568		0x0021
 #define PCI_DEVICE_ID_MPC8567E		0x0022
 #define PCI_DEVICE_ID_MPC8567		0x0023
-#define PCI_DEVICE_ID_MPC8544E		0x0030
-#define PCI_DEVICE_ID_MPC8544		0x0031
+#define PCI_DEVICE_ID_MPC8533E		0x0030
+#define PCI_DEVICE_ID_MPC8533		0x0031
+#define PCI_DEVICE_ID_MPC8544E		0x0032
+#define PCI_DEVICE_ID_MPC8544		0x0033
 #define PCI_DEVICE_ID_MPC8641		0x7010
 #define PCI_DEVICE_ID_MPC8641D		0x7011

