Return-Path: <linux-kernel-owner+w=401wt.eu-S1757727AbYJKByA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727AbYJKByA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 21:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbYJKBxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 21:53:52 -0400
Received: from coliposte.enst-bretagne.fr ([192.108.115.12]:43357 "EHLO
	coliposte.enst-bretagne.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116AbYJKBxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 21:53:52 -0400
X-Greylist: delayed 3761 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Oct 2008 21:53:51 EDT
Message-ID: <48EFF858.2050007@enst-bretagne.fr>
Date: Sat, 11 Oct 2008 02:50:32 +0200
From: Florent Fourcot <florent.fourcot@enst-bretagne.fr>
Reply-To: florent.fourcot@enst-bretagne.fr
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: larry.finger@lwfinger.net, linville@tuxdriver.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] rtl8187 : support of Belkin "F5D7050rev5000de"
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
this Belkin product (id 050d:705e) use Realtek’s RTL8187B and work fine
with new 2.6.27 driver. Please consider to add support of this card.


--- linux-2.6.27/drivers/net/wireless/rtl8187_dev.c
+++ linux-2.6.27-modif/drivers/net/wireless/rtl8187_dev.c
@@ -33,6 +33,8 @@
 static struct usb_device_id rtl8187_table[] __devinitdata = {
        /* Asus */
        {USB_DEVICE(0x0b05, 0x171d), .driver_info = DEVICE_RTL8187},
+       /* Belkin */
+       {USB_DEVICE(0x050d, 0x705e), .driver_info = DEVICE_RTL8187B},
        /* Realtek */
        {USB_DEVICE(0x0bda, 0x8187), .driver_info = DEVICE_RTL8187},
        {USB_DEVICE(0x0bda, 0x8189), .driver_info = DEVICE_RTL8187B},


-- 
Florent Fourcot.
