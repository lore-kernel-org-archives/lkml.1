Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787Ab0A0AF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab0A0AF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068Ab0AZXnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:43:05 -0500
Received: from kroah.org ([198.145.64.141]:35102 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003Ab0AZXnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:03 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:22 2010
Message-Id: <20100126233922.026532672@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kumar Gala <galak@kernel.crashing.org>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [09/98] [stable] [PATCH] powerpc/fsl: Add PCI device ids for new QoirQ chips
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit a3f62bd2b20c769ddc989b242ddd274179e19ee6 upstream by
Kumar Gala <galak@kernel.crashing.org>.  I have adjusted the patch
context for 2.6.32.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/sysdev/fsl_pci.c |   14 ++++++++++++++
 include/linux/pci_ids.h       |   14 ++++++++++++++
 2 files changed, 28 insertions(+)

--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -392,8 +392,22 @@ DECLARE_PCI_FIXUP_HEADER(0x1957, PCI_DEV
 DECLARE_PCI_FIXUP_HEADER(0x1957, PCI_DEVICE_ID_MPC8641, quirk_fsl_pcie_header);
 DECLARE_PCI_FIXUP_HEADER(0x1957, PCI_DEVICE_ID_MPC8641D, quirk_fsl_pcie_header);
 DECLARE_PCI_FIXUP_HEADER(0x1957, PCI_DEVICE_ID_MPC8610, quirk_fsl_pcie_header);
+DECLARE_PCI_FIXUP_HEADER(0x1957, PCI_DEVICE_ID_P1011E, quirk_fsl_pcie_header);
+DECLARE_PCI_FIXUP_HEADER(0x1957, PCI_DEVICE_ID_P1011, quirk_fsl_pcie_header);
+DECLARE_PCI_FIXUP_HEADER(0x1957, PCI_DEVICE_ID_P1013E, quirk_fsl_pcie_header);
+DECLARE_PCI_FIXUP_HEADER(0x1957, PCI_DEVICE_ID_P1013, quirk_fsl_pcie_header);
+DECLARE_PCI_FIXUP_HEADER(0x1957, PCI_DEVICE_ID_P1020E, quirk_fsl_pcie_header);
+DECLARE_PCI_FIXUP_HEADER(0x1957, PCI_DEVICE_ID_P1020, quirk_fsl_pcie_header);
+DECLARE_PCI_FIXUP_HEADER(0x1957, PCI_DEVICE_ID_P1022E, quirk_fsl_pcie_header);
+DECLARE_PCI_FIXUP_HEADER(0x1957, PCI_DEVICE_ID_P1022, quirk_fsl_pcie_header);
+DECLARE_PCI_FIXUP_HEADER(0x1957, PCI_DEVICE_ID_P2010E, quirk_fsl_pcie_header);
+DECLARE_PCI_FIXUP_HEADER(0x1957, PCI_DEVICE_ID_P2010, quirk_fsl_pcie_header);
 DECLARE_PCI_FIXUP_HEADER(0x1957, PCI_DEVICE_ID_P2020E, quirk_fsl_pcie_header);
 DECLARE_PCI_FIXUP_HEADER(0x1957, PCI_DEVICE_ID_P2020, quirk_fsl_pcie_header);
+DECLARE_PCI_FIXUP_HEADER(0x1957, PCI_DEVICE_ID_P4040E, quirk_fsl_pcie_header);
+DECLARE_PCI_FIXUP_HEADER(0x1957, PCI_DEVICE_ID_P4040, quirk_fsl_pcie_header);
+DECLARE_PCI_FIXUP_HEADER(0x1957, PCI_DEVICE_ID_P4080E, quirk_fsl_pcie_header);
+DECLARE_PCI_FIXUP_HEADER(0x1957, PCI_DEVICE_ID_P4080, quirk_fsl_pcie_header);
 #endif /* CONFIG_PPC_85xx || CONFIG_PPC_86xx */
 
 #if defined(CONFIG_PPC_83xx) || defined(CONFIG_PPC_MPC512x)
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2290,6 +2290,20 @@
 #define PCI_DEVICE_ID_MPC8536		0x0051
 #define PCI_DEVICE_ID_P2020E		0x0070
 #define PCI_DEVICE_ID_P2020		0x0071
+#define PCI_DEVICE_ID_P2010E		0x0078
+#define PCI_DEVICE_ID_P2010		0x0079
+#define PCI_DEVICE_ID_P1020E		0x0100
+#define PCI_DEVICE_ID_P1020		0x0101
+#define PCI_DEVICE_ID_P1011E		0x0108
+#define PCI_DEVICE_ID_P1011		0x0109
+#define PCI_DEVICE_ID_P1022E		0x0110
+#define PCI_DEVICE_ID_P1022		0x0111
+#define PCI_DEVICE_ID_P1013E		0x0118
+#define PCI_DEVICE_ID_P1013		0x0119
+#define PCI_DEVICE_ID_P4080E		0x0400
+#define PCI_DEVICE_ID_P4080		0x0401
+#define PCI_DEVICE_ID_P4040E		0x0408
+#define PCI_DEVICE_ID_P4040		0x0409
 #define PCI_DEVICE_ID_MPC8641		0x7010
 #define PCI_DEVICE_ID_MPC8641D		0x7011
 #define PCI_DEVICE_ID_MPC8610		0x7018


