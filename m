Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbYKPJpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbYKPJpo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 04:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbYKPJoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 04:44:22 -0500
Received: from mail-gx0-f29.google.com ([209.85.217.29]:63598 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbYKPJoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 04:44:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:bcc:subject:date:user-agent:message-id;
        b=JKLmUMNW+C0vRwc3zeQei/fz2vKhmoQ7M6nhSyYPZhW4he5WOi9iR+f/EKTkvGTWM0
         6XnjaAUCrJChaViiaZ27w+ZJejXoNyhQdywE7SirQApZtLurghIG5lBBscD1tMpKT17n
         9Z/rH5mky1+KtW9bEaeVb+8Xmle2KBG+KDw/s=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: qhfeng.kernel@gmail.com, Randy Dunlap <rdunlap@xenotime.net>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: [PATCH 5/7] drivers/ata/pata_legacy.c: cleanup kernel-doc
Date: Sun, 16 Nov 2008 17:44:08 +0800
User-Agent: sniper-patch-carrier/1.04
Message-ID: <491feb71.044e6e0a.74c1.ffffeeab@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No argument named @irq in qdi6580dp_set_piomode
remove it.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 930c220..cfb35a7 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -641,7 +641,6 @@ static void qdi6500_set_piomode(struct ata_port *ap, struct ata_device *adev)
  *	qdi6580dp_set_piomode		-	PIO setup for dual channel
  *	@ap: Port
  *	@adev: Device
- *	@irq: interrupt line
  *
  *	In dual channel mode the 6580 has one clock per channel and we have
  *	to software clockswitch in qc_issue.

