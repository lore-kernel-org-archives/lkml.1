Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbYGJDoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbYGJDoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 23:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbYGJDo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 23:44:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:12486 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594AbYGJDo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 23:44:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,335,1212390000"; 
   d="scan'208,223";a="305085938"
From: "Yang, Sheng" <sheng.yang@intel.com>
Organization: Intel
To: linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] PCI: Add Bridge Configuration Retry bit in PCIE Control
Date: Thu, 10 Jul 2008 11:45:43 +0800
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_nXYdIuGoR4dExgT"
Message-Id: <200807101145.43839.sheng.yang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_nXYdIuGoR4dExgT
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=46rom 7d8f4016eac2ac2877412b6c510616da4e08415e Mon Sep 17 00:00:00 2001
=46rom: Sheng Yang <sheng.yang@intel.com>
Date: Thu, 10 Jul 2008 11:43:33 +0800
Subject: [PATCH] PCI: Add Bridge Configuration Retry bit in PCIE=20
Control

The bit 15 is Bridge Configuration Retry Reset and Initiate Function=20
Level Reset bit.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
=2D--
 include/linux/pci_regs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index c0c1223..36ce86b 100644
=2D-- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -387,6 +387,7 @@
 #define  PCI_EXP_DEVCTL_AUX_PME	0x0400	/* Auxiliary Power PM Enable=20
*/
 #define  PCI_EXP_DEVCTL_NOSNOOP_EN 0x0800  /* Enable No Snoop */
 #define  PCI_EXP_DEVCTL_READRQ	0x7000	/* Max_Read_Request_Size */
+#define  PCI_EXP_DEVCTL_BCR_FLR 0x8000  /* Bridge Configuration=20
Retry / FLR */
 #define PCI_EXP_DEVSTA		10	/* Device Status */
 #define  PCI_EXP_DEVSTA_CED	0x01	/* Correctable Error Detected */
 #define  PCI_EXP_DEVSTA_NFED	0x02	/* Non-Fatal Error Detected */
=2D-
1.5.6


--Boundary-00=_nXYdIuGoR4dExgT
Content-Type: text/x-diff;
  charset="utf-8";
  name="0001-PCI-Add-Bridge-Configuration-Retry-bit-in-PCIE-Cont.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-PCI-Add-Bridge-Configuration-Retry-bit-in-PCIE-Cont.patch"

=46rom 7d8f4016eac2ac2877412b6c510616da4e08415e Mon Sep 17 00:00:00 2001
=46rom: Sheng Yang <sheng.yang@intel.com>
Date: Thu, 10 Jul 2008 11:43:33 +0800
Subject: [PATCH] PCI: Add Bridge Configuration Retry bit in PCIE Control

The bit 15 is Bridge Configuration Retry Reset and Initiate Function Level =
Reset
bit.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
=2D--
 include/linux/pci_regs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index c0c1223..36ce86b 100644
=2D-- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -387,6 +387,7 @@
 #define  PCI_EXP_DEVCTL_AUX_PME	0x0400	/* Auxiliary Power PM Enable */
 #define  PCI_EXP_DEVCTL_NOSNOOP_EN 0x0800  /* Enable No Snoop */
 #define  PCI_EXP_DEVCTL_READRQ	0x7000	/* Max_Read_Request_Size */
+#define  PCI_EXP_DEVCTL_BCR_FLR 0x8000  /* Bridge Configuration Retry / FL=
R */
 #define PCI_EXP_DEVSTA		10	/* Device Status */
 #define  PCI_EXP_DEVSTA_CED	0x01	/* Correctable Error Detected */
 #define  PCI_EXP_DEVSTA_NFED	0x02	/* Non-Fatal Error Detected */
=2D-=20
1.5.6


--Boundary-00=_nXYdIuGoR4dExgT--
