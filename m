Return-Path: <linux-kernel-owner+w=401wt.eu-S935406AbXK3Q2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935406AbXK3Q2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 11:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933612AbXK3Q2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 11:28:22 -0500
Received: from ag-out-0708.google.com ([72.14.246.241]:52978 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbXK3Q2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 11:28:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=IRf6Fqppr/a2C4PkdviM7q97uhlWg0dBYglfIOnO6RfuPTfS3hhNA5J5vToNKH0wljqU03CSqfX3mA+Pkb9MyDDFz8QdN2W1GhdQ0EONSaHFuYMgpkorOhfrHkcznDO1RHrQPqEXn98TuvWejB6eZHChcCQ+vN3ho5P2iJWLRtY=
Date: Fri, 30 Nov 2007 16:30:11 +0000
From: Jaime Velasco Juan <jsagarribay@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Johann Wilhelm <johann.wilhelm@student.tugraz.at>,
       Rui Santos <rsantos@grupopie.com>, Pete Zaitcev <zaitcev@redhat.com>,
       linux-usb@vger.kernel.org, preining@logic.at,
       kristoffer.ericson@gmail.com, drussell@redhat.com,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH] USB: option: Bind to the correct interface of the Huawei
	E220
Message-ID: <20071130163011.GA4223@singular.local>
References: <20071128161305.b01167b3.zaitcev@redhat.com> <20071129150550.86453nubw8i5xi68@webmail.tugraz.at> <20071129185339.GA10445@singular.local> <200711300023.08999.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711300023.08999.oliver@neukum.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Jaime Velasco Juan <jsagarribay@gmail.com>
---

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index a18659e..352c94c 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -158,8 +158,8 @@ static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_MODEM) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_NETWORK) },
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E600) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220BIS) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220BIS, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1100) }, /* Novatel Merlin XS620/S640 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1110) }, /* Novatel Merlin S620 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1120) }, /* Novatel Merlin EX720 */
