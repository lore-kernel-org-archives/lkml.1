Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbZLGAQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbZLGAQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758660AbZLGAP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:15:56 -0500
Received: from kroah.org ([198.145.64.141]:34765 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934384AbZLGAOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:14:08 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:07:00 2009
Message-Id: <20091207000700.391172996@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?ISO-8859-15?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [113/119] V4L/DVB (13256): gspca - m5602-s5k4aa: Add another MSI GX700 vflip quirk
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=v4l-dvb-13256-gspca-m5602-s5k4aa-add-another-msi-gx700-vflip-quirk.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Erik Andrén <erik.andren@gmail.com>

commit 2339a1887dab469bb4bae56aa7eca3a5e05ecde7 upstream.

Adds another vflip quirk for the MSI GX700.
Thanks to John Katzmaier for reporting.

Signed-off-by: Erik Andrén <erik.andren@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
+++ b/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
@@ -58,6 +58,13 @@ static
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "GX700"),
+			DMI_MATCH(DMI_BIOS_DATE, "12/02/2008")
+		}
+	}, {
+		.ident = "MSI GX700",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GX700"),
 			DMI_MATCH(DMI_BIOS_DATE, "07/26/2007")
 		}
 	}, {


