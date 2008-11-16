Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbYKPJpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbYKPJpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 04:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYKPJoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 04:44:17 -0500
Received: from mail-gx0-f29.google.com ([209.85.217.29]:46879 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbYKPJoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 04:44:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:bcc:subject:date:user-agent:message-id;
        b=NKc+Slb/LY9XAEuA7jjdNxSD4mOW/C79LWzTlr1hm+zGjXOoBYnGMNPiv2DVohGtGR
         YtmHE3GYWzXIxiwiOo7eqMS/MdG789cAfWM+pm2xkxK/Tumjea70jWs64A9SXKv3PDLO
         8G3jzoK0lVyECYgy4By8lMJgFa/6ThBesLMno=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: qhfeng.kernel@gmail.com, Randy Dunlap <rdunlap@xenotime.net>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: [PATCH 4/7] drivers/ata/pata_pdc2027x.c: cleanup kernel-doc
Date: Sun, 16 Nov 2008 17:44:02 +0800
User-Agent: sniper-patch-carrier/1.04
Message-ID: <491feb6c.044e6e0a.74c1.ffffee9b@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No argument named @pio in pdc2027x_set_piomode, and
no argument named @udma in pdc2027x_set_dmamode,
remove them.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index 0e1c2c1..22a1f7d 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -281,7 +281,6 @@ static unsigned long pdc2027x_mode_filter(struct ata_device *adev, unsigned long
  *	pdc2027x_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port to configure
  *	@adev: um
- *	@pio: PIO mode, 0 - 4
  *
  *	Set PIO mode for device.
  *
@@ -326,7 +325,6 @@ static void pdc2027x_set_piomode(struct ata_port *ap, struct ata_device *adev)
  *	pdc2027x_set_dmamode - Initialize host controller PATA UDMA timings
  *	@ap: Port to configure
  *	@adev: um
- *	@udma: udma mode, XFER_UDMA_0 to XFER_UDMA_6
  *
  *	Set UDMA mode for device.
  *

