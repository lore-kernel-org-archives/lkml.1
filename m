Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbZLGAQC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbZLGAQC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:16:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758503AbZLGAP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:15:59 -0500
Received: from kroah.org ([198.145.64.141]:34759 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934385AbZLGAOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:14:07 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:07:00 2009
Message-Id: <20091207000700.226177942@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?ISO-8859-15?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [112/119] V4L/DVB (13255): gspca - m5602-s5k4aa: Add vflip quirk for the Bruneinit laptop
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=v4l-dvb-13255-gspca-m5602-s5k4aa-add-vflip-quirk-for-the-bruneinit-laptop.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Erik Andrén <erik.andren@gmail.com>

commit b6ef8836c1ff5199abd40cfba162052bc7e8af00 upstream.

Adds a vflip quirk for the Bruneinit laptop. Thanks to Jörg for the report

Signed-off-by: Erik Andrén <erik.andren@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
+++ b/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
@@ -35,6 +35,13 @@ static
     const
 	struct dmi_system_id s5k4aa_vflip_dmi_table[] = {
 	{
+		.ident = "BRUNEINIT",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "BRUNENIT"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "BRUNENIT"),
+			DMI_MATCH(DMI_BOARD_VERSION, "00030D0000000001")
+		}
+	}, {
 		.ident = "Fujitsu-Siemens Amilo Xa 2528",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),


