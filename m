Return-Path: <linux-kernel-owner+w=401wt.eu-S935142AbZLQBWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935142AbZLQBWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763753AbZLQBVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:21:23 -0500
Received: from kroah.org ([198.145.64.141]:41561 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763731AbZLQBVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:21:12 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:09 2009
Message-Id: <20091217011609.752672621@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Rafal Milecki <zajec5@gmail.com>, Jean-Francois Moine <moinejf@free.fr>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Surbhi Palande <surbhi.palande@canonical.com>
Subject: [90/90] V4L/DVB (13116): gspca - ov519: Webcam 041e:4067 added.
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafal Milecki <zajec5@gmail.com>

commit 518c8df77c21b7d1690dd8b96eb0e54c4ec1c9c1 upstream.

Signed-off-by: Rafal Milecki <zajec5@gmail.com>
Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Surbhi Palande <surbhi.palande@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/video4linux/gspca.txt |    1 +
 drivers/media/video/gspca/ov519.c   |    1 +
 2 files changed, 2 insertions(+)

--- a/Documentation/video4linux/gspca.txt
+++ b/Documentation/video4linux/gspca.txt
@@ -37,6 +37,7 @@ ov519		041e:405f	Creative Live! VISTA VF
 ov519		041e:4060	Creative Live! VISTA VF0350
 ov519		041e:4061	Creative Live! VISTA VF0400
 ov519		041e:4064	Creative Live! VISTA VF0420
+ov519		041e:4067	Creative Live! Cam Video IM (VF0350)
 ov519		041e:4068	Creative Live! VISTA VF0470
 spca561		0458:7004	Genius VideoCAM Express V2
 sunplus		0458:7006	Genius Dsc 1.3 Smart
--- a/drivers/media/video/gspca/ov519.c
+++ b/drivers/media/video/gspca/ov519.c
@@ -3364,6 +3364,7 @@ static const __devinitdata struct usb_de
 	{USB_DEVICE(0x041e, 0x4061), .driver_info = BRIDGE_OV519 },
 	{USB_DEVICE(0x041e, 0x4064),
 	 .driver_info = BRIDGE_OV519 | BRIDGE_INVERT_LED },
+	{USB_DEVICE(0x041e, 0x4067), .driver_info = BRIDGE_OV519 },
 	{USB_DEVICE(0x041e, 0x4068),
 	 .driver_info = BRIDGE_OV519 | BRIDGE_INVERT_LED },
 	{USB_DEVICE(0x045e, 0x028c), .driver_info = BRIDGE_OV519 },


