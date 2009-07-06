Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbZGFMZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbZGFMZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 08:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbZGFMZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 08:25:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35003 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbZGFMZp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 08:25:45 -0400
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "trivial@kernel.org" <trivial@kernel.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Date: Mon, 6 Jul 2009 17:52:54 +0530
Subject: [PATCH] Trivial: Fix typo "for for"
Thread-Topic: [PATCH] Trivial: Fix typo "for for"
Thread-Index: Acn+NHzCXhIsXstmTt+FsV/u+2L2wg==
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB0305C11131@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anand Gadiyar <gadiyar@ti.com>

Trivial: Fix typo "for for"

Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
---
 drivers/usb/host/ehci-pci.c |    2 +-
 drivers/usb/host/ehci.h     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-omap-2.6/drivers/usb/host/ehci-pci.c
===================================================================
--- linux-omap-2.6.orig/drivers/usb/host/ehci-pci.c
+++ linux-omap-2.6/drivers/usb/host/ehci-pci.c
@@ -242,7 +242,7 @@ static int ehci_pci_setup(struct usb_hcd
 	 * System suspend currently expects to be able to suspend the entire
 	 * device tree, device-at-a-time.  If we failed selective suspend
 	 * reports, system suspend would fail; so the root hub code must claim
-	 * success.  That's lying to usbcore, and it matters for for runtime
+	 * success.  That's lying to usbcore, and it matters for runtime
 	 * PM scenarios with selective suspend and remote wakeup...
 	 */
 	if (ehci->no_selective_suspend && device_can_wakeup(&pdev->dev))
Index: linux-omap-2.6/drivers/usb/host/ehci.h
===================================================================
--- linux-omap-2.6.orig/drivers/usb/host/ehci.h
+++ linux-omap-2.6/drivers/usb/host/ehci.h
@@ -37,7 +37,7 @@ typedef __u16 __bitwise __hc16;
 #define __hc16	__le16
 #endif
 
-/* statistics can be kept for for tuning/monitoring */
+/* statistics can be kept for tuning/monitoring */
 struct ehci_stats {
 	/* irq usage */
 	unsigned long		normal;
