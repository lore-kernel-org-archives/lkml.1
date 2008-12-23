Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbYLWWDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbYLWWDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 17:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbYLWWC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 17:02:56 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:57583 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbYLWWCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 17:02:55 -0500
Date: Tue, 23 Dec 2008 22:54:07 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH] pci-quirks: HP hides SMBus controller in Compaq nx9500 laptops
Message-ID: <20081223215407.GB32525@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found no references to SMBus in ACPI DSDT disassembly on my laptop
so this should be safe.

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

diff -urN linux-2.6.27.7-brfix1-nvpid/drivers/pci/quirks.c pci-quirks/drivers/pci/quirks.c
--- linux-2.6.27.7-brfix1-nvpid/drivers/pci/quirks.c	2008-10-10 00:13:53.000000000 +0200
+++ pci-quirks/drivers/pci/quirks.c	2008-12-06 22:18:46.000000000 +0100
@@ -1040,6 +1040,7 @@
 			switch (dev->subsystem_device) {
 			case 0x12bc: /* HP D330L */
 			case 0x12bd: /* HP D530 */
+			case 0x006a: /* HP Compaq nx9500 */
 				asus_hides_smbus = 1;
 			}
 		else if (dev->device == PCI_DEVICE_ID_INTEL_82875_HB)
