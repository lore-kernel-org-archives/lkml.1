Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbYKDPVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbYKDPVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYKDPVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:21:22 -0500
Received: from tombstone.ecm.ub.es ([161.116.81.124]:4455 "EHLO
	tombstone.ecm.ub.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbYKDPVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:21:22 -0500
Message-ID: <49106865.1080009@ecm.ub.es>
Date: Tue, 04 Nov 2008 16:21:09 +0100
From: Albert Comerma <albert@ecm.ub.es>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Somebody will apply it?
Content-Type: multipart/mixed;
 boundary="------------040007060205080104000108"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040007060205080104000108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Since my previous message seems did not arrive anyone interested I 
repeat it, stressing that the maintainer seems not to maintain the 
driver, so somebody with access should apply the patch. It's a trivial 
patch...

-------- Missatge original --------
Assumpte: 	[PATCH] to SIS USB2VGA DRIVER
Data: 	Mon, 03 Nov 2008 15:23:46 +0100
De: 	Albert Comerma <albert@ecm.ub.es>
A: 	linux-kernel@vger.kernel.org



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




--------------040007060205080104000108
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


--------------040007060205080104000108--
