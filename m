Return-Path: <linux-kernel-owner+w=401wt.eu-S965605AbXBTAQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965605AbXBTAQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965637AbXBTAP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:15:27 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36112 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750934AbXBTAHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:07:41 -0500
Date: Tue, 20 Feb 2007 01:07:40 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [-mm patch] make drivers/usb/misc/iowarrior.c:iowarrior_ids[] static
Message-ID: <20070220000740.GZ13958@stusta.de>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 05:14:08AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc6-mm3:
>...
> +gregkh-usb-usb-iowarrior.patch
>...
>  USB tree updates
>...


This patch makes the needlessly global struct iowarrior_ids[] static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.20-mm2/drivers/usb/misc/iowarrior.c.old	2007-02-18 22:32:11.000000000 +0100
+++ linux-2.6.20-mm2/drivers/usb/misc/iowarrior.c	2007-02-18 22:32:20.000000000 +0100
@@ -140,7 +140,7 @@
 /* driver registration */
 /*---------------------*/
 /* table of devices that work with this driver */
-struct usb_device_id iowarrior_ids[] = {
+static struct usb_device_id iowarrior_ids[] = {
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW40)},
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW24)},
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOWPV1)},

