Return-Path: <linux-kernel-owner+w=401wt.eu-S934096AbYBGU6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934096AbYBGU6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761365AbYBGUv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:51:27 -0500
Received: from mail.suse.de ([195.135.220.2]:45393 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933202AbYBGUvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:51:25 -0500
Date: Thu, 7 Feb 2008 12:47:13 -0800
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
       Akira Tsukamoto <akirat@rd.scei.sony.co.jp>
Subject: [patch 15/45] USB: pl2303: add support for RATOC REX-USB60F
Message-ID: <20080207204713.GP16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-pl2303-add-support-for-ratoc-rex-usb60f.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Akira Tsukamoto <akirat@rd.scei.sony.co.jp>

pl2303: add support for RATOC REX-USB60F

This patch adds support for RATOC REX-USB60F Serial Adapters,
which is widely used in Japan recently.

Signed-off-by: Akira Tsukamoto <akirat@rd.scei.sony.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -65,6 +65,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(ITEGNO_VENDOR_ID, ITEGNO_PRODUCT_ID_2080) },
 	{ USB_DEVICE(MA620_VENDOR_ID, MA620_PRODUCT_ID) },
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID) },
+	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
 	{ USB_DEVICE(TRIPP_VENDOR_ID, TRIPP_PRODUCT_ID) },
 	{ USB_DEVICE(RADIOSHACK_VENDOR_ID, RADIOSHACK_PRODUCT_ID) },
 	{ USB_DEVICE(DCU10_VENDOR_ID, DCU10_PRODUCT_ID) },
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -35,6 +35,7 @@
 
 #define RATOC_VENDOR_ID		0x0584
 #define RATOC_PRODUCT_ID	0xb000
+#define RATOC_PRODUCT_ID_USB60F	0xb020
 
 #define TRIPP_VENDOR_ID		0x2478
 #define TRIPP_PRODUCT_ID	0x2008

-- 
