Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbYE0Rko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbYE0Rko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbYE0Rkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:40:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64097 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbYE0Rkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:40:32 -0400
Message-ID: <483C478E.9000908@onlinehome.de>
Date: Tue, 27 May 2008 19:40:30 +0200
From: Felix Homann <fexpop@onlinehome.de>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [Patch]: USB ID for Philips CPWUA054/00 Wireless USB Adapter 11g
Content-Type: multipart/mixed;
 boundary="------------060606040609050405030908"
X-Provags-ID: V01U2FsdGVkX1+bJVHNEUZEvap5ZYUgcq7P2PF/OggvER45UDk
 vVHc+fUZ2htXkr/1xfKGwTHgr3AgED3uLS5cr/Iu2VnwxqqEvI
 Fvw7AMeE9TAUrKxbdmVVW8kQ0nOCdZl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060606040609050405030908
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

here's a patch to enable the Philips CPWUA054/00 in p54usb.

You might want to include it in future kernels. (At least I would like 
to see it included ;-)


Kind regards,

Felix

--------------060606040609050405030908
Content-Type: text/x-diff;
 name="CPWUA054_00.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="CPWUA054_00.patch"

diff --git a/drivers/net/wireless/p54usb.c b/drivers/net/wireless/p54usb.c
index 98ddbb3..1610a73 100644
--- a/drivers/net/wireless/p54usb.c
+++ b/drivers/net/wireless/p54usb.c
@@ -49,6 +49,7 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 	{USB_DEVICE(0x5041, 0x2235)},	/* Linksys WUSB54G Portable */
 
 	/* Version 2 devices (3887) */
+	{USB_DEVICE(0x0471, 0x1230)},   /* Philips CPWUA054/00 */
 	{USB_DEVICE(0x050d, 0x7050)},	/* Belkin F5D7050 ver 1000 */
 	{USB_DEVICE(0x0572, 0x2000)},	/* Cohiba Proto board */
 	{USB_DEVICE(0x0572, 0x2002)},	/* Cohiba Proto board */

--------------060606040609050405030908--
