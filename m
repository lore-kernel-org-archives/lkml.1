Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab0BMUVv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 15:21:51 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:60140 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757966Ab0BMUVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 15:21:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=eO12IoY7I+RxGENDlcr/mJ9TnUyUT85R29Kr7nm3MR8p72TsX0mt6QDRjxKH64j35F
         zu5MwYu20CX/yNdR2s0YZrjO7JXlQI9R+z9y0T61lxBd44tUX5y6D0wPZBB7olHBhxRk
         +1A4mWwaff0WQej2FX5V90eXWhxaTq2rURp6c=
From: Graham M Howe <gman.1352@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Staging: comedi: bracing fix to ni_atmio.c This is a patch to ni_atmio.c file to fix up bracing style problems found by checkpatch.pl tool Signed-off-by: Graham M Howe <gman.1352@googlemail.com>
Date: Sat, 13 Feb 2010 20:21:43 +0000
Message-Id: <1266092503-5115-1-git-send-email-user@graham-eeepc>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: root <root@graham-eeepc.(none)>

---
 drivers/staging/comedi/drivers/ni_atmio.c |   34 ++++++++++++++--------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_atmio.c b/drivers/staging/comedi/drivers/ni_atmio.c
index 8ead311..003d00b 100644
--- a/drivers/staging/comedi/drivers/ni_atmio.c
+++ b/drivers/staging/comedi/drivers/ni_atmio.c
@@ -329,11 +329,11 @@ static uint16_t ni_atmio_win_in(struct comedi_device *dev, int addr)
 }

 static struct pnp_device_id device_ids[] = {
-	{.id = "NIC1900",.driver_data = 0},
-	{.id = "NIC2400",.driver_data = 0},
-	{.id = "NIC2500",.driver_data = 0},
-	{.id = "NIC2600",.driver_data = 0},
-	{.id = "NIC2700",.driver_data = 0},
+	{.id = "NIC1900", .driver_data = 0},
+	{.id = "NIC2400", .driver_data = 0},
+	{.id = "NIC2500", .driver_data = 0},
+	{.id = "NIC2600", .driver_data = 0},
+	{.id = "NIC2700", .driver_data = 0},
 	{.id = ""}
 };

@@ -362,9 +362,9 @@ static int ni_atmio_detach(struct comedi_device *dev)

 	if (dev->iobase)
 		release_region(dev->iobase, NI_SIZE);
-	if (dev->irq) {
+	if (dev->irq)
 		free_irq(dev->irq, dev);
-	}
+
 	if (devpriv->isapnp_dev)
 		pnp_device_detach(devpriv->isapnp_dev);

@@ -387,8 +387,8 @@ static int ni_isapnp_find_board(struct pnp_dev **dev)

 		if (pnp_device_attach(isapnp_dev) < 0) {
 			printk
-			    ("ni_atmio: %s found but already active, skipping.\n",
-			     ni_boards[i].name);
+			 ("ni_atmio: %s found but already active, skipping.\n",
+			  ni_boards[i].name);
 			continue;
 		}
 		if (pnp_activate_dev(isapnp_dev) < 0) {
@@ -496,9 +496,9 @@ static int ni_atmio_attach(struct comedi_device *dev,
 	/* generic E series stuff in ni_mio_common.c */

 	ret = ni_E_init(dev, it);
-	if (ret < 0) {
+	if (ret < 0)
 		return ret;
-	}
+

 	return 0;
 }
@@ -509,16 +509,16 @@ static int ni_getboardtype(struct comedi_device *dev)
 	int i;

 	for (i = 0; i < n_ni_boards; i++) {
-		if (ni_boards[i].device_id == device_id) {
+		if (ni_boards[i].device_id == device_id)
 			return i;
-		}
+
 	}
-	if (device_id == 255) {
+	if (device_id == 255)
 		printk(" can't find board\n");
-	} else if (device_id == 0) {
+	 else if (device_id == 0)
 		printk(" EEPROM read error (?) or device not found\n");
-	} else {
+	 else
 		printk(" unknown device ID %d -- contact author\n", device_id);
-	}
+
 	return -1;
 }
--
1.6.3.3

