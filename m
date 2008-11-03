Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYKCOtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYKCOtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbYKCOtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:49:45 -0500
Received: from tombstone.ecm.ub.es ([161.116.81.124]:1525 "EHLO
	tombstone.ecm.ub.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbYKCOto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:49:44 -0500
X-Greylist: delayed 1545 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Nov 2008 09:49:43 EST
Message-ID: <490F0972.4000303@ecm.ub.es>
Date: Mon, 03 Nov 2008 15:23:46 +0100
From: Albert Comerma <albert@ecm.ub.es>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] to SIS USB2VGA DRIVER
Content-Type: multipart/mixed;
 boundary="------------000401000902060206020003"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000401000902060206020003
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi list!, first of all I'm not subscrived to the list but would be great 
if you CC me the answers for this mail.
I write because a long time ago I detected that just adding a new USB ID 
to the USB2VGA driver it can work with a new adapter. I contacted the 
maintainer as appeared in the MAINTAINERS list;

SIS FRAMEBUFFER DRIVER
P:      Thomas Winischhofer
M:      thomas@winischhofer.net
W:      http://www.winischhofer.net/linuxsisvga.shtml
S:      Maintained

SIS USB2VGA DRIVER
P:      Thomas Winischhofer
M:      thomas@winischhofer.net
W:      http://www.winischhofer.at/linuxsisusbvga.shtml
S:      Maintained

He didn't answered nor added the line, and his web seems down.
So it would be great if somebody could do this for him.
I send the patch...

Cheers,

Albert


--------------000401000902060206020003
Content-Type: text/x-diff;
 name="sisusb.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sisusb.patch"

diff -r -u linux-2.6.27.4/drivers/usb/misc/sisusbvga/sisusb.c linux-2.6.27.4-new/drivers/usb/misc/sisusbvga/sisusb.c
--- linux-2.6.27.4/drivers/usb/misc/sisusbvga/sisusb.c	2008-10-26 00:05:07.000000000 +0200
+++ linux-2.6.27.4-new/drivers/usb/misc/sisusbvga/sisusb.c	2008-11-03 15:21:03.000000000 +0100
@@ -3270,6 +3270,7 @@
 	{ USB_DEVICE(0x0711, 0x0900) },
 	{ USB_DEVICE(0x0711, 0x0901) },
 	{ USB_DEVICE(0x0711, 0x0902) },
+	{ USB_DEVICE(0x0711, 0x0903) },
 	{ USB_DEVICE(0x0711, 0x0918) },
 	{ USB_DEVICE(0x182d, 0x021c) },
 	{ USB_DEVICE(0x182d, 0x0269) },

--------------000401000902060206020003--
