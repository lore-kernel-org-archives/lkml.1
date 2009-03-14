Return-Path: <linux-kernel-owner+w=401wt.eu-S1760935AbZCNB36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760935AbZCNB36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbZCNBUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:20 -0400
Received: from kroah.org ([198.145.64.141]:34991 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753329AbZCNBUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:08 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:35 2009
Message-Id: <20090314011035.388345080@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 027/114] USB: option: add BenQ 3g modem information
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=usb-option-add-benq-3g-modem-information.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Sung <jsung@novell.com>

commit 28fb66821f884870987a0b5ab064ef651d9f7c16 upstream.

This patch addes the BenQ 3g modem support to the option driver.


From: Jesse Sung <jsung@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -289,6 +289,9 @@ static int  option_send_setup(struct tty
 #define ERICSSON_VENDOR_ID			0x0bdb
 #define ERICSSON_PRODUCT_F3507G			0x1900
 
+#define BENQ_VENDOR_ID				0x04a5
+#define BENQ_PRODUCT_H10			0x4068
+
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -498,6 +501,8 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF628) },
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH) },
 	{ USB_DEVICE(ERICSSON_VENDOR_ID, ERICSSON_PRODUCT_F3507G) },
+	{ USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
+	{ USB_DEVICE(0x1da5, 0x4515) }, /* BenQ H20 */
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


