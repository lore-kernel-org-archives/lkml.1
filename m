Return-Path: <linux-kernel-owner+w=401wt.eu-S1760047AbYD2UIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbYD2UIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755920AbYD2UIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:08:44 -0400
Received: from carmdsmtp.sierrawireless.com ([208.81.121.7]:38505 "EHLO
	mx1.sierrawireless.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615AbYD2UIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:08:43 -0400
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Apr 2008 16:08:43 EDT
From: Kevin Lloyd <klloyd@sierrawireless.com>
To: Tim Gardner <timg@tpi.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tim.gardner@canonical.com" <tim.gardner@canonical.com>,
       "greg@kroah.com" <greg@kroah.com>
Date: Tue, 29 Apr 2008 12:56:22 -0700
Subject: RE: [PATCH] USB: sierra: add support for Onda H600/Zte MF330
Thread-Topic: [PATCH] USB: sierra: add support for Onda H600/Zte MF330
Thread-Index: AciqMjcRCjugLEH8SC+B3gWSE0vCZAAAG0Tw
Message-ID: <20719A9A7E5F8040AC0590F6F6C1DF460EEE0672E7@uscbd-exchmb01.sierrawireless.local>
References: <20080429194710.174E2BB413C@sepang.rtg.net>
In-Reply-To: <20080429194710.174E2BB413C@sepang.rtg.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 29 Apr 2008 19:56:26.0134 (UTC) FILETIME=[1B7DC360:01C8AA33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

The sierra device driver is really trying to focus on Sierra vendor specific features and it might not be the best approach to add a Onda/Zte device here. Might I suggest the option driver? That is where the other Onda/Zte devices are stored.

-Kevin

-----Original Message-----
From: Tim Gardner [mailto:timg@tpi.com]
Sent: Tuesday, April 29, 2008 12:47 PM
To: Kevin Lloyd
Cc: linux-kernel@vger.kernel.org; tim.gardner@canonical.com
Subject: [PATCH] USB: sierra: add support for Onda H600/Zte MF330

From: Bruno Redondi <bruno.redondi@altarisoluzione.com>
Date: Fri, 1 Feb 2008 15:16:52 -0800
Subject: [PATCH] USB: sierra: add support for Onda H600/Zte MF330 datacard to USB Driver for
 Sierra Wireless

Added support for Onda H600/Zte MF330 GPRS/UMTS/HSDPA datacard

Signed-off-by: Bruno Redondi <bruno.redondi@altarisoluzione.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Amit Kucheria <amit.kucheria@ubuntu.com>
Cc: stable@kernel.org
---
 drivers/usb/serial/sierra.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index ed67881..da5a519 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -179,6 +179,7 @@ static struct usb_device_id id_table [] = {

        { USB_DEVICE(0x1199, 0x0112), .driver_info = DEVICE_1_PORT }, /* Sierra Wireless AirCard 580 */
        { USB_DEVICE(0x0F3D, 0x0112), .driver_info = DEVICE_1_PORT }, /* Airprime/Sierra PC 5220 */
+       { USB_DEVICE(0x05C6, 0x6613), .driver_info = DEVICE_1_PORT }, /* Onda H600/ZTE MF330 */

        { USB_DEVICE(0x1199, 0x0FFF), .driver_info = DEVICE_INSTALLER},
        { }
--
1.5.4.3


