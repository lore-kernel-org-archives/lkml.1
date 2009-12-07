Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbZLGAOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbZLGAOu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758391AbZLGAOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:14:37 -0500
Received: from kroah.org ([198.145.64.141]:34770 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934392AbZLGAOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:14:10 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:07:00 2009
Message-Id: <20091207000700.567771288@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?ISO-8859-15?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [114/119] V4L/DVB (13257): gspca - m5602-s5k4aa: Add vflip for Fujitsu Amilo Xi 2528
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=v4l-dvb-13257-gspca-m5602-s5k4aa-add-vflip-for-fujitsu-amilo-xi-2528.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Erik Andrén <erik.andren@gmail.com>

commit 81191f694cb507c49d3c7aa6238dcc0a83ad4001 upstream.

Adds a vflip quirk for the Fujitsu Amilo Xi 2528. Thanks to Evgeny for the report.

Signed-off-by: Erik Andrén <erik.andren@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/gspca/m5602/m5602_s5k4aa.c b/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
index ef4ae68..a27afeb 100644
--- a/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
+++ b/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
@@ -48,6 +48,12 @@ static
 			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Xa 2528")
 		}
 	}, {
+		.ident = "Fujitsu-Siemens Amilo Xi 2528",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Xi 2528")
+		}
+	}, {
 		.ident = "Fujitsu-Siemens Amilo Xi 2550",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),


