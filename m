Return-Path: <linux-kernel-owner+w=401wt.eu-S1764785AbXHNPq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764785AbXHNPq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758915AbXHNPqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:46:37 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:34597 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005AbXHNPqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:46:36 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Paolo Ornati <ornati@fastwebnet.it>
Subject: Re: [linux-usb-devel] spontaneous disconnect with "usb-storage: implement autosuspend"
Date: Tue, 14 Aug 2007 17:46:16 +0200
User-Agent: KMail/1.9.7
Cc: linux-usb-devel@lists.sourceforge.net,
       Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070814131557.5653d991@localhost> <200708141530.28182.oliver@neukum.org> <20070814154747.6272ccf3@localhost>
In-Reply-To: <20070814154747.6272ccf3@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708141746.16958.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 14 August 2007 schrieb Paolo Ornati:
> Hewlett-Packard PhotoSmart 720 / PhotoSmart 935 (storage)

Please try this patch.

	Regards
		Oliver

-----

--- a/drivers/usb/core/quirks.c	2007-08-14 17:42:22.000000000 +0200
+++ b/drivers/usb/core/quirks.c	2007-08-14 17:43:51.000000000 +0200
@@ -30,6 +30,8 @@
 static const struct usb_device_id usb_quirk_list[] = {
 	/* HP 5300/5370C scanner */
 	{ USB_DEVICE(0x03f0, 0x0701), .driver_info = USB_QUIRK_STRING_FETCH_255 },
+	/* Hewlett-Packard PhotoSmart 720 / PhotoSmart 935 (storage) */
+	{ USB_DEVICE(0x03f0, 0x4002), .driver_info = USB_QUIRK_RESET_RESUME },
 	/* Acer Peripherals Inc. (now BenQ Corp.) Prisa 640BU */
 	{ USB_DEVICE(0x04a5, 0x207e), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
 	/* Benq S2W 3300U */

