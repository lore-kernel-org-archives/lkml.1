Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab0CKTpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 14:45:40 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53610 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737Ab0CKTpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 14:45:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        b=gO6br1wQ779vDvfbfmfZTf4iH3PQ+Ywuh1ah932llnL2bmJJenMPQmSJ/FkuyiJICo
         eGvPbZe575sCYXrYa2dr0O4r0RWTKGUvfZEH10Rcza3bo5SmL2rMgIEf018EXYwYYv2s
         CmRT5d3bng+M/l8tswCekKZZo3tJ0Hd9KE1fc=
Date: Thu, 11 Mar 2010 13:45:35 -0600 (CST)
From: Robert Babilon <robert.babilon@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, linux@dominikbrodowski.net,
       keil@b1-systems.de
cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: patch for file ni_daq_700.c
Message-ID: <alpine.DEB.2.00.1003111342390.25539@robert-desktopkde4>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a4db480a5dfc9912a52a43e57a0775c013c3bb09 Mon Sep 17 00:00:00 2001
From: Robert Babilon <robert.babilon@gmail.com>
Date: Thu, 11 Mar 2010 13:08:55 -0600
Subject: [PATCH] Staging: comedi: fix export symbol warnings in ni_daq_700.c
 This is a patch to the ni_daq_700.c file that fixes several EXPORT_SYMBOL
 warnings found by the checkpatch.pl tool
 Signed-off-by: Robert Babilon <robert.babilon@gmail.com>

---
 drivers/staging/comedi/drivers/ni_daq_700.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index c9b0395..c67fdfc 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -144,6 +144,7 @@ void subdev_700_interrupt(struct comedi_device *dev, struct comedi_subdevice *s)
 
 	comedi_event(dev, s);
 }
+EXPORT_SYMBOL(subdev_700_interrupt);
 
 static int subdev_700_cb(int dir, int port, int data, unsigned long arg)
 {
@@ -325,6 +326,7 @@ int subdev_700_init(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	return 0;
 }
+EXPORT_SYMBOL(subdev_700_init);
 
 int subdev_700_init_irq(struct comedi_device *dev, struct comedi_subdevice *s,
 			int (*cb) (int, int, int, unsigned long),
@@ -344,6 +346,7 @@ int subdev_700_init_irq(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	return 0;
 }
+EXPORT_SYMBOL(subdev_700_init_irq);
 
 void subdev_700_cleanup(struct comedi_device *dev, struct comedi_subdevice *s)
 {
@@ -352,11 +355,7 @@ void subdev_700_cleanup(struct comedi_device *dev, struct comedi_subdevice *s)
 
 			kfree(s->private);
 }
-
-EXPORT_SYMBOL(subdev_700_init);
-EXPORT_SYMBOL(subdev_700_init_irq);
 EXPORT_SYMBOL(subdev_700_cleanup);
-EXPORT_SYMBOL(subdev_700_interrupt);
 
 static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
-- 
1.6.3.3

