Return-Path: <linux-kernel-owner+w=401wt.eu-S1759914AbZCQQRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914AbZCQQRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 12:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbZCQQRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 12:17:05 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:46294 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608AbZCQQRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 12:17:04 -0400
Message-Id: <49BFDB3C.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 17 Mar 2009 16:17:48 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-pci@vger.kernel.org>
Cc: "Dexuan Cui" <dexuan.cui@intel.com>, <stable@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH] pci: Fix the definition of PCI_PM_CTRL_NO_SOFT_RESET
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dexuan Cui <dexuan.cui@intel.com>

As per PCI Bus Power Management Interface Specification Revision 1.2
this is bit 3, not bit 2, of the Power Management Control/Status
register.

Signed-off-by: Dexuan Cui <dexuan.cui@intel.com>
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: stable <stable@kernel.org>

---
 include/linux/pci_regs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.29-rc8/include/linux/pci_regs.h	2009-03-17 17:14:16.000000000 +0100
+++ 2.6.29-rc8-pci-pm-ctrl-no-soft-reset/include/linux/pci_regs.h	2009-03-04 11:25:28.000000000 +0100
@@ -235,7 +235,7 @@
 #define  PCI_PM_CAP_PME_SHIFT	11	/* Start of the PME Mask in PMC */
 #define PCI_PM_CTRL		4	/* PM control and status register */
 #define  PCI_PM_CTRL_STATE_MASK	0x0003	/* Current power state (D0 to D3) */
-#define  PCI_PM_CTRL_NO_SOFT_RESET	0x0004	/* No reset for D3hot->D0 */
+#define  PCI_PM_CTRL_NO_SOFT_RESET	0x0008	/* No reset for D3hot->D0 */
 #define  PCI_PM_CTRL_PME_ENABLE	0x0100	/* PME pin enable */
 #define  PCI_PM_CTRL_DATA_SEL_MASK	0x1e00	/* Data select (??) */
 #define  PCI_PM_CTRL_DATA_SCALE_MASK	0x6000	/* Data scale (??) */



