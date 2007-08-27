Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbXH0BLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbXH0BLX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 21:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbXH0BLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 21:11:15 -0400
Received: from relais.videotron.ca ([24.201.245.36]:44519 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbXH0BLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 21:11:14 -0400
Date: Sun, 26 Aug 2007 21:11:12 -0400
From: Jonathan Bastien-Filiatrault <joe@dastyle.net>
Subject: [PATCH] Document the fact that smsc-ircc2 will not use PNP by default
To: linux-kernel@vger.kernel.org
Message-id: <46D224B0.2060000@dastyle.net>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_9n6VT3PfQtfJs4mWKeVLOQ)"
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070621)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_9n6VT3PfQtfJs4mWKeVLOQ)
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT

This avoids user confusion when they see that their device is not detected.

---
  drivers/net/irda/smsc-ircc2.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

--Boundary_(ID_9n6VT3PfQtfJs4mWKeVLOQ)
Content-type: text/x-patch; CHARSET=US-ASCII;
 name=084845a8adb2fde43fd8865f2bad07df781e79a8.diff
Content-transfer-encoding: 7BIT
Content-disposition: inline;
 filename=084845a8adb2fde43fd8865f2bad07df781e79a8.diff

diff --git a/drivers/net/irda/smsc-ircc2.c b/drivers/net/irda/smsc-ircc2.c
index 36ab983..a8a0b2c 100644
--- a/drivers/net/irda/smsc-ircc2.c
+++ b/drivers/net/irda/smsc-ircc2.c
@@ -81,7 +81,7 @@ MODULE_LICENSE("GPL");
 
 static int smsc_nopnp = 1;
 module_param_named(nopnp, smsc_nopnp, bool, 0);
-MODULE_PARM_DESC(nopnp, "Do not use PNP to detect controller settings");
+MODULE_PARM_DESC(nopnp, "Do not use PNP to detect controller settings, defaults to true");
 
 #define DMA_INVAL 255
 static int ircc_dma = DMA_INVAL;


--Boundary_(ID_9n6VT3PfQtfJs4mWKeVLOQ)--
