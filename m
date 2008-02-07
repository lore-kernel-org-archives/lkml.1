Return-Path: <linux-kernel-owner+w=401wt.eu-S933167AbYBGUyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbYBGUyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933100AbYBGUuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:50:51 -0500
Received: from cantor.suse.de ([195.135.220.2]:45058 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933064AbYBGUut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:50:49 -0500
Date: Thu, 7 Feb 2008 12:46:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-usb@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 07/45] USB: add support for 4348:5523 WinChipHead USB->RS
	232 adapter
Message-ID: <20080207204652.GH16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-add-support-for-4348-5523-winchiphead-usb-rs-232-adapter.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Piotr Roszatycki <dexter@debian.org>

add support for:

  4348:5523 WinChipHead USB->RS 232 adapter with Prolifec PL 2303 chipset

[ mingo@elte.hu: merged it and nursed it upstream ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    5 +++++
 2 files changed, 6 insertions(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -87,6 +87,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_ID) },
 	{ USB_DEVICE(WS002IN_VENDOR_ID, WS002IN_PRODUCT_ID) },
 	{ USB_DEVICE(COREGA_VENDOR_ID, COREGA_PRODUCT_ID) },
+	{ USB_DEVICE(HL340_VENDOR_ID, HL340_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -107,3 +107,8 @@
 /* Corega CG-USBRS232R Serial Adapter */
 #define COREGA_VENDOR_ID	0x07aa
 #define COREGA_PRODUCT_ID	0x002a
+
+/* HL HL-340 (ID: 4348:5523) */
+#define HL340_VENDOR_ID		0x4348
+#define HL340_PRODUCT_ID	0x5523
+

-- 
