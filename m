Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391Ab0AZXwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab0AZXwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859Ab0AZXv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:51:59 -0500
Received: from kroah.org ([198.145.64.141]:35426 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692Ab0AZXoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:01 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:29 2010
Message-Id: <20100126233929.799327675@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Imre Kaloz <kaloz@openwrt.org>, Wim Van Sebroeck <wim@iguana.be>
Subject: [68/98] [WATCHDOG] iTCO_wdt: add PCI ID for the Intel EP80579 (Tolapai) SoC
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Imre Kaloz <kaloz@openwrt.org>

commit 4946f8353da9d3038e2a9d0295d5dfeee4cee5c5 upstream.

add PCI ID for the Intel EP80579 (Tolapai) SoC

Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/watchdog/iTCO_wdt.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -30,6 +30,7 @@
  *	document number 316972-004, 316973-012: 82801I (ICH9)
  *	document number 319973-002, 319974-002: 82801J (ICH10)
  *	document number 322169-001, 322170-001: 5 Series, 3400 Series (PCH)
+ *	document number 320066-003, 320257-008: EP80597 (IICH)
  */
 
 /*
@@ -100,6 +101,7 @@ enum iTCO_chipsets {
 	TCO_PCH,	/* PCH Desktop Full Featured */
 	TCO_PCHM,	/* PCH Mobile Full Featured */
 	TCO_PCHMSFF,	/* PCH Mobile SFF Full Featured */
+	TCO_EP80579,	/* EP80579 */
 };
 
 static struct {
@@ -143,6 +145,7 @@ static struct {
 	{"PCH Desktop Full Featured", 2},
 	{"PCH Mobile Full Featured", 2},
 	{"PCH Mobile SFF Full Featured", 2},
+	{"EP80579", 2},
 	{NULL, 0}
 };
 
@@ -214,6 +217,7 @@ static struct pci_device_id iTCO_wdt_pci
 	{ ITCO_PCI_DEVICE(0x3b00,				TCO_PCH)},
 	{ ITCO_PCI_DEVICE(0x3b01,				TCO_PCHM)},
 	{ ITCO_PCI_DEVICE(0x3b0d,				TCO_PCHMSFF)},
+	{ ITCO_PCI_DEVICE(0x5031,				TCO_EP80579)},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);


