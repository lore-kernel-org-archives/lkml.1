Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353Ab0AZXvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab0AZXvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363Ab0AZXvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:51:37 -0500
Received: from kroah.org ([198.145.64.141]:35431 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab0AZXoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:03 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:30 2010
Message-Id: <20100126233929.928925643@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Seth Heasley <seth.heasley@intel.com>, Wim Van Sebroeck <wim@iguana.be>,
       Jiri Kosina <jkosina@suse.cz>
Subject: [69/98] [WATCHDOG] iTCO_wdt: Add Intel Cougar Point and PCH DeviceIDs
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Seth Heasley <seth.heasley@intel.com>

commit 3c9d8eccd8687f0e770e4d89fd0d73d4f81a985a upstream.

This patch adds the Intel Cougar Point and PCH DeviceIDs for iTCO Watchdog.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/watchdog/iTCO_wdt.c |   45 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -29,8 +29,9 @@
  *	document number 313056-003, 313057-017: 82801H (ICH8)
  *	document number 316972-004, 316973-012: 82801I (ICH9)
  *	document number 319973-002, 319974-002: 82801J (ICH10)
- *	document number 322169-001, 322170-001: 5 Series, 3400 Series (PCH)
+ *	document number 322169-001, 322170-003: 5 Series, 3400 Series (PCH)
  *	document number 320066-003, 320257-008: EP80597 (IICH)
+ *	document number TBD                   : Cougar Point (CPT)
  */
 
 /*
@@ -100,8 +101,22 @@ enum iTCO_chipsets {
 	TCO_ICH10DO,	/* ICH10DO */
 	TCO_PCH,	/* PCH Desktop Full Featured */
 	TCO_PCHM,	/* PCH Mobile Full Featured */
+	TCO_P55,	/* P55 */
+	TCO_PM55,	/* PM55 */
+	TCO_H55,	/* H55 */
+	TCO_QM57,	/* QM57 */
+	TCO_H57,	/* H57 */
+	TCO_HM55,	/* HM55 */
+	TCO_Q57,	/* Q57 */
+	TCO_HM57,	/* HM57 */
 	TCO_PCHMSFF,	/* PCH Mobile SFF Full Featured */
+	TCO_QS57,	/* QS57 */
+	TCO_3400,	/* 3400 */
+	TCO_3420,	/* 3420 */
+	TCO_3450,	/* 3450 */
 	TCO_EP80579,	/* EP80579 */
+	TCO_CPTD,	/* CPT Desktop */
+	TCO_CPTM,	/* CPT Mobile */
 };
 
 static struct {
@@ -144,8 +159,22 @@ static struct {
 	{"ICH10DO", 2},
 	{"PCH Desktop Full Featured", 2},
 	{"PCH Mobile Full Featured", 2},
+	{"P55", 2},
+	{"PM55", 2},
+	{"H55", 2},
+	{"QM57", 2},
+	{"H57", 2},
+	{"HM55", 2},
+	{"Q57", 2},
+	{"HM57", 2},
 	{"PCH Mobile SFF Full Featured", 2},
+	{"QS57", 2},
+	{"3400", 2},
+	{"3420", 2},
+	{"3450", 2},
 	{"EP80579", 2},
+	{"CPT Desktop", 2},
+	{"CPT Mobile", 2},
 	{NULL, 0}
 };
 
@@ -216,8 +245,22 @@ static struct pci_device_id iTCO_wdt_pci
 	{ ITCO_PCI_DEVICE(0x3a14,				TCO_ICH10DO)},
 	{ ITCO_PCI_DEVICE(0x3b00,				TCO_PCH)},
 	{ ITCO_PCI_DEVICE(0x3b01,				TCO_PCHM)},
+	{ ITCO_PCI_DEVICE(0x3b02,				TCO_P55)},
+	{ ITCO_PCI_DEVICE(0x3b03,				TCO_PM55)},
+	{ ITCO_PCI_DEVICE(0x3b06,				TCO_H55)},
+	{ ITCO_PCI_DEVICE(0x3b07,				TCO_QM57)},
+	{ ITCO_PCI_DEVICE(0x3b08,				TCO_H57)},
+	{ ITCO_PCI_DEVICE(0x3b09,				TCO_HM55)},
+	{ ITCO_PCI_DEVICE(0x3b0a,				TCO_Q57)},
+	{ ITCO_PCI_DEVICE(0x3b0b,				TCO_HM57)},
 	{ ITCO_PCI_DEVICE(0x3b0d,				TCO_PCHMSFF)},
+	{ ITCO_PCI_DEVICE(0x3b0f,				TCO_QS57)},
+	{ ITCO_PCI_DEVICE(0x3b12,				TCO_3400)},
+	{ ITCO_PCI_DEVICE(0x3b14,				TCO_3420)},
+	{ ITCO_PCI_DEVICE(0x3b16,				TCO_3450)},
 	{ ITCO_PCI_DEVICE(0x5031,				TCO_EP80579)},
+	{ ITCO_PCI_DEVICE(0x1c42,				TCO_CPTD)},
+	{ ITCO_PCI_DEVICE(0x1c43,				TCO_CPTM)},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);


