Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbZAIKse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbZAIKse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbZAIKsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:48:19 -0500
Received: from rv-out-0506.google.com ([209.85.198.227]:2981 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152AbZAIKsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:48:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=GSvl4BtDDR/Zw23G9UwTCw0drCPwO8L7exNrfP0hg+YF/MMU/kHHgC6lYY8p//p4NV
         w8qc1SVOQmJahMvjMKFKte0lCuqz/HsJA/BAOygtk29lkqJgYtl6JpxeMzN+JfOevRf7
         4Uac/RehVHzHLXb5lAqn2wHa+kvike4238Za4=
Message-ID: <177c2b150901090248y57ec2cffra40c42bc47cfe55a@mail.gmail.com>
Date: Fri, 9 Jan 2009 06:48:16 -0400
From: "Mhayk Whandson" <eu@mhayk.com.br>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [PATCH] ftdi_sio driver support of bar code scanner from Diebold
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, kuba@mareimbrium.org,
       bryder@sgi.com
In-Reply-To: <200901090915.08458.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <177c2b150901082152g13515bf2q9575523e28a17f92@mail.gmail.com>
	 <200901090915.08458.oliver@neukum.org>
X-Google-Sender-Auth: e85d2901ec1818dd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n09AmvwM029344

Added the product id of bcs(bar code scanner) from Diebold Procomp Brazil.
Signed-off-by: Mhayk Whandson <eu@mhayk.com.br>
--- linux-2.6.28/drivers/usb/serial/ftdi_sio.h.orig     2009-01-0906:34:44.000000000 -0400+++ linux-2.6.28/drivers/usb/serial/ftdi_sio.h  2009-01-0906:35:10.000000000 -0400@@ -20,6 +20,9 @@  * Philipp GÃ¼hring - pg@futureware.at - added the Device ID of the USB relais  * from Rudolf Gugler  *+ * Mhayk Whandson - eu@mhayk.com.br - added the Product ID of the USB Bar Code+ * Scanner from Diebold Procomp Brazil.+ *  */
 #define FTDI_VID       0x0403  /* Vendor Id */@@ -881,6 +884,11 @@ #define RATOC_PRODUCT_ID_USB60F        0xb020
 /*+ * DIEBOLD BCS SE923+ */+#define DIEBOLD_BCS_SE923_PID 0xfb99++/*  *   BmRequestType:  1100 0000b  *   bRequest:       FTDI_E2_READ  *   wValue:         0--- linux-2.6.28/drivers/usb/serial/ftdi_sio.c.orig     2009-01-0906:34:38.000000000 -0400+++ linux-2.6.28/drivers/usb/serial/ftdi_sio.c  2009-01-0906:35:10.000000000 -0400@@ -660,6 +660,7 @@ static struct usb_device_id id_table_com        { USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO4x4_PID) },        { USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DGQG_PID) },        { USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DUSB_PID) },+       { USB_DEVICE(FTDI_VID, DIEBOLD_BCS_SE923_PID) },        { },                                    /* Optional parameter entry */        { }                                     /* Terminating entry */ };

-- Mhayk WhandsonLinux User #413723E-mail: eu@mhayk.com.brÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
