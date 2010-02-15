Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab0BOJ6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 04:58:32 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:38201 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab0BOJ6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 04:58:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=l0qL2Y7ZCbZ3/9i4XznxmAI71BDL4CoDE/VyTQHc+hY81tLISZn4ya/MUs0YFV1CHH
         ggVhm1koMceayZpPGkwkE9VMnYG1QCzqHsEFjDuOE9CeoByqOKd5szgPbHlQv04Ipeji
         lXv+q6382UoekTBfr34a5KR1QyOb4vtWIQxcg=
From: Graham M Howe <gman.1352@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Graham M Howe <gman.1352@googlemail.com>
Subject: [PATCH 4/4] Staging: comedi: fix brace and 80 character coding style issue in ni_daq_700.c
Date: Mon, 15 Feb 2010 09:58:17 +0000
Message-Id: <1266227897-2373-1-git-send-email-gman.1352@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: root <root@graham-eeepc.(none)>

This is a patch to the ni_daq_700.c file that fixes up brace and 80 character warnings
found by the checkpatch.pl tool

Signed-off-by: Graham M Howe <gman.1352@googlemail.com>
---
 drivers/staging/comedi/drivers/ni_daq_700.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index ef5e118..c9b0395 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -76,13 +76,15 @@ struct dio700_board {
 static const struct dio700_board dio700_boards[] = {
 	{
 	 .name = "daqcard-700",
-	 .device_id = 0x4743,	/*  0x10b is manufacturer id, 0x4743 is device id */
+	  /*  0x10b is manufacturer id, 0x4743 is device id */
+	 .device_id = 0x4743,
 	 .bustype = pcmcia_bustype,
 	 .have_dio = 1,
 	 },
 	{
 	 .name = "ni_daq_700",
-	 .device_id = 0x4743,	/*  0x10b is manufacturer id, 0x4743 is device id */
+	  /*  0x10b is manufacturer id, 0x4743 is device id */
+	 .device_id = 0x4743,
 	 .bustype = pcmcia_bustype,
 	 .have_dio = 1,
 	 },
@@ -309,11 +311,11 @@ int subdev_700_init(struct comedi_device *dev, struct comedi_subdevice *s,
 		return -ENOMEM;

 	CALLBACK_ARG = arg;
-	if (cb == NULL) {
+	if (cb == NULL)
 		CALLBACK_FUNC = subdev_700_cb;
-	} else {
+	 else
 		CALLBACK_FUNC = cb;
-	}
+
 	s->insn_bits = subdev_700_insn;
 	s->insn_config = subdev_700_insn_config;

@@ -345,12 +347,10 @@ int subdev_700_init_irq(struct comedi_device *dev, struct comedi_subdevice *s,

 void subdev_700_cleanup(struct comedi_device *dev, struct comedi_subdevice *s)
 {
-	if (s->private) {
-		if (subdevpriv->have_irq) {
-		}
+	if (s->private)
+		if (subdevpriv->have_irq)

-		kfree(s->private);
-	}
+			kfree(s->private);
 }

 EXPORT_SYMBOL(subdev_700_init);
@@ -390,9 +390,9 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	printk("comedi%d: ni_daq_700: %s, io 0x%lx", dev->minor,
 	       thisboard->name, iobase);
 #ifdef incomplete
-	if (irq) {
+	if (irq)
 		printk(", irq %u", irq);
-	}
+
 #endif

 	printk("\n");
--
1.6.3.3

