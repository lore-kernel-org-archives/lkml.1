Return-Path: <linux-kernel-owner+w=401wt.eu-S932253AbYFGBNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbYFGBNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbYFGBJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:06 -0400
Received: from sous-sol.org ([216.99.217.87]:42395 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759934AbYFGBJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:02 -0400
Message-Id: <20080607010551.202275376@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:20 -0700
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
       Dan Williams <dcbw@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 05/50] USB: option: add new Dell 5520 HSDPA variant
Content-Disposition: inline; filename=usb-option-add-new-dell-5520-hsdpa-variant.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Dan Williams <dcbw@redhat.com>

commit 96cb15cf977356d9d3117dd88f3fe187d6024f4b upstream

New variant of the 5520 found by Luke Sheldrick.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/usb/serial/option.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -293,6 +293,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8133) }, /* Dell Wireless 5720 == Novatel EV620 CDMA/EV-DO */
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8136) },	/* Dell Wireless HSDPA 5520 == Novatel Expedite EU860D */
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8137) },	/* Dell Wireless HSDPA 5520 */
+	{ USB_DEVICE(DELL_VENDOR_ID, 0x8138) },	/* Dell Wireless 5520 Voda I Mobile Broadband (3G HSDPA) Minicard */
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_E100A) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },
 	{ USB_DEVICE(AXESSTEL_VENDOR_ID, AXESSTEL_PRODUCT_MV110H) },

-- 
