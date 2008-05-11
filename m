Return-Path: <linux-kernel-owner+w=401wt.eu-S1751531AbYEKQXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbYEKQXY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 12:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbYEKQXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 12:23:15 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:29937 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbYEKQXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 12:23:14 -0400
Message-ID: <7c541bae0805110923r42c9d234i3930e646de0823d6@mail.gmail.com>
Date: Sun, 11 May 2008 09:23:13 -0700
From: "Bernhard Beck" <kernel@goodcoffee.net>
To: torvalds@linux-foundation.org, gregkh@suse.de
Subject: [PATCH 001/001] usb-serial: Add ThinkOptics WavIT
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: e02a1ccd35b3d001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ThinkOptics WavIt to cp2101 device table
Signed-off-by: Bernhard Beck <kernel@goodcoffee.net>
---

--- linux-2.6.25.3/drivers/usb/serial/cp2101.c-orig     2008-05-11
08:47:34.000000000 -0700
+++ linux-2.6.25.3/drivers/usb/serial/cp2101.c  2008-05-11
08:48:01.000000000 -0700
@@ -71,6 +71,7 @@ static struct usb_device_id id_table []
        { USB_DEVICE(0x10C4, 0x814A) }, /* West Mountain Radio RIGblaster P&P */
        { USB_DEVICE(0x10C4, 0x814B) }, /* West Mountain Radio RIGtalk */
        { USB_DEVICE(0x10C4, 0x815E) }, /* Helicomm IP-Link 1220-DVM */
+       { USB_DEVICE(0x10C4, 0x81A6) }, /* ThinkOptics WavIt */
        { USB_DEVICE(0x10C4, 0x81C8) }, /* Lipowsky Industrie
Elektronik GmbH, Baby-JTAG */
        { USB_DEVICE(0x10C4, 0x81E2) }, /* Lipowsky Industrie
Elektronik GmbH, Baby-LIN */
        { USB_DEVICE(0x10C4, 0x81E7) }, /* Aerocomm Radio */
