Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbYABKRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbYABKRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 05:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbYABKRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 05:17:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37085 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474AbYABKRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 05:17:12 -0500
Date: Wed, 2 Jan 2008 11:16:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: dexter@debian.org, linux-kernel@vger.kernel.org
Subject: [patch]  usb: add support for 4348:5523 WinChipHead USB->RS 232
	adapter
Message-ID: <20080102101657.GA9380@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

find the patch from Piotr Roszatycki, submitted to:

  http://bugzilla.kernel.org/show_bug.cgi?id=9626

as an email plain-text patch submission below.

	Ingo

------------>
Subject: usb: add support for 4348:5523 WinChipHead USB->RS 232 adapter with Prolifec PL 2303 chipset
From: Piotr Roszatycki <dexter@debian.org>

add support for:

  4348:5523 WinChipHead USB->RS 232 adapter with Prolifec PL 2303 chipset

[ mingo@elte.hu: merged it and nursed it upstream ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    5 +++++
 2 files changed, 6 insertions(+)

Index: linux-x86.q/drivers/usb/serial/pl2303.c
===================================================================
--- linux-x86.q.orig/drivers/usb/serial/pl2303.c
+++ linux-x86.q/drivers/usb/serial/pl2303.c
@@ -87,6 +87,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_ID) },
 	{ USB_DEVICE(WS002IN_VENDOR_ID, WS002IN_PRODUCT_ID) },
 	{ USB_DEVICE(COREGA_VENDOR_ID, COREGA_PRODUCT_ID) },
+	{ USB_DEVICE(HL340_VENDOR_ID, HL340_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
Index: linux-x86.q/drivers/usb/serial/pl2303.h
===================================================================
--- linux-x86.q.orig/drivers/usb/serial/pl2303.h
+++ linux-x86.q/drivers/usb/serial/pl2303.h
@@ -107,3 +107,8 @@
 /* Corega CG-USBRS232R Serial Adapter */
 #define COREGA_VENDOR_ID	0x07aa
 #define COREGA_PRODUCT_ID	0x002a
+
+/* HL HL-340 (ID: 4348:5523) */
+#define HL340_VENDOR_ID		0x4348
+#define HL340_PRODUCT_ID	0x5523
+
