Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732Ab0A0ADz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab0A0ADz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725Ab0A0ADs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:03:48 -0500
Received: from kroah.org ([198.145.64.141]:35141 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082Ab0AZXnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:12 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:23 2010
Message-Id: <20100126233923.356237628@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Seth Heasley <seth.heasley@intel.com>, Wim Van Sebroeck <wim@iguana.be>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [19/98] [WATCHDOG] iTCO_wdt: Add support for Intel Ibex Peak
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Seth Heasley <seth.heasley@intel.com>

commit 79e8941dda254505bb8af37b3a009165dfb7e98a upstream.

Add the Intel Ibex Peak (PCH) Device IDs to iTCO_wdt.c.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/watchdog/iTCO_wdt.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -54,7 +54,9 @@
  *	82801JIB (ICH10)     : document number 319973-002, 319974-002,
  *	82801JIR (ICH10R)    : document number 319973-002, 319974-002,
  *	82801JD  (ICH10D)    : document number 319973-002, 319974-002,
- *	82801JDO (ICH10DO)   : document number 319973-002, 319974-002
+ *	82801JDO (ICH10DO)   : document number 319973-002, 319974-002,
+ *	5 Series (PCH)       : document number 322169-001, 322170-001,
+ *	3400 Series (PCH)    : document number 322169-001, 322170-001
  */
 
 /*
@@ -122,6 +124,9 @@ enum iTCO_chipsets {
 	TCO_ICH10R,	/* ICH10R */
 	TCO_ICH10D,	/* ICH10D */
 	TCO_ICH10DO,	/* ICH10DO */
+	TCO_PCH,	/* PCH Desktop Full Featured */
+	TCO_PCHM,	/* PCH Mobile Full Featured */
+	TCO_PCHMSFF,	/* PCH Mobile SFF Full Featured */
 };
 
 static struct {
@@ -162,6 +167,9 @@ static struct {
 	{"ICH10R", 2},
 	{"ICH10D", 2},
 	{"ICH10DO", 2},
+	{"PCH Desktop Full Featured", 2},
+	{"PCH Mobile Full Featured", 2},
+	{"PCH Mobile SFF Full Featured", 2},
 	{NULL, 0}
 };
 
@@ -230,6 +238,9 @@ static struct pci_device_id iTCO_wdt_pci
 	{ ITCO_PCI_DEVICE(0x3a16,				TCO_ICH10R)},
 	{ ITCO_PCI_DEVICE(0x3a1a,				TCO_ICH10D)},
 	{ ITCO_PCI_DEVICE(0x3a14,				TCO_ICH10DO)},
+	{ ITCO_PCI_DEVICE(0x3b00,				TCO_PCH)},
+	{ ITCO_PCI_DEVICE(0x3b01,				TCO_PCHM)},
+	{ ITCO_PCI_DEVICE(0x3b0d,				TCO_PCHMSFF)},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);


