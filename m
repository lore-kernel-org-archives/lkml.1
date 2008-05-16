Return-Path: <linux-kernel-owner+w=401wt.eu-S1760644AbYEPSmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644AbYEPSmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 14:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759927AbYEPSl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 14:41:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652AbYEPSl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 14:41:56 -0400
Date: Fri, 16 May 2008 15:41:40 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Matthias Urlichs <smurf@smurf.noris.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Augusto Campos <brain@matrix.com.br>
Subject: [PATCH][OPTION]: Add id for Onda MSA501HS HSDPA modem
Message-ID: <20080516184140.GA8111@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Matthias Urlichs <smurf@smurf.noris.de>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	Augusto Campos <brain@matrix.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthias,

	Please consider adding the following USB product id to the
option GSM modem driver.

        Using the generic usbserial kernel driver I can only get to
~490 Kbit/s, while when using your excellent driver I'm being able to
saturate the 1 Mbit/s bandwidth I subscribed from TIM WEB here in Brazil.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Best Regards,

- Arnaldo

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index e7e016e..47be78b 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -183,6 +183,7 @@ static int  option_send_setup(struct usb_serial_port *port);
 #define AXESSTEL_PRODUCT_MV110H			0x1000
 
 #define ONDA_VENDOR_ID				0x19d2
+#define ONDA_PRODUCT_MSA501HS			0x0001
 #define ONDA_PRODUCT_ET502HS			0x0002
 
 #define BANDRICH_VENDOR_ID			0x1A8D
@@ -297,6 +298,7 @@ static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_E100A) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },
 	{ USB_DEVICE(AXESSTEL_VENDOR_ID, AXESSTEL_PRODUCT_MV110H) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_PRODUCT_MSA501HS) },
 	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_PRODUCT_ET502HS) },
 	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_1) },
 	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_2) },
