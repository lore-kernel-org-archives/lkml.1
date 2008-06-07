Return-Path: <linux-kernel-owner+w=401wt.eu-S933616AbYFGB2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616AbYFGB2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760655AbYFGBKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:10:01 -0400
Received: from sous-sol.org ([216.99.217.87]:42589 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708AbYFGBJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:58 -0400
Message-Id: <20080607010604.395806888@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:33 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Greg Kroah-Hartman <gregkh@suse.de>, Simon Kissel <kissel@viprinet.com>,
       Nico Erfurth <ne@nicoerfurth.de>, Andrea Ghezzo <TS-EMEA@telit.com>,
       Dietmar Staps <Dietmar.Staps@telit.com>
Subject: [patch 18/50] USB: add TELIT HDSPA UC864-E modem to option driver
Content-Disposition: inline; filename=usb-add-telit-hdspa-uc864-e-modem-to-option-driver.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

upstream commit: ee53b0ca0153b4f944cb142b5e65c96a1860d765

This adds the Telit UC864-E HDSPA modem support to the option driver.
This lets their customers comply with the GPL instead of having to use a
binary driver from the manufacturer.

Cc: Simon Kissel <kissel@viprinet.com>
Cc: Nico Erfurth <ne@nicoerfurth.de>
Cc: Andrea Ghezzo <TS-EMEA@telit.com>
Cc: Dietmar Staps <Dietmar.Staps@telit.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/usb/serial/option.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -193,6 +193,9 @@ static int  option_send_setup(struct usb
 
 #define MAXON_VENDOR_ID				0x16d8
 
+#define TELIT_VENDOR_ID				0x1bc7
+#define TELIT_PRODUCT_UC864E			0x1003
+
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -300,6 +303,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
 	{ USB_DEVICE(MAXON_VENDOR_ID, 0x6280) }, /* BP3-USB & BP3-EXT HSDPA */
 	{ USB_DEVICE(0x19d2, 0x0001) }, 	/* Telstra NextG CDMA */
+	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864E) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);

-- 
