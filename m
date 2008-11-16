Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbYKPJqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbYKPJqB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 04:46:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbYKPJo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 04:44:28 -0500
Received: from ag-out-0708.google.com ([72.14.246.242]:46937 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbYKPJoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 04:44:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:bcc:subject:date:user-agent:message-id;
        b=VzpoPgpcWE4mRHxXAIUqGROL6wdy6Hdjsq/Mg3/7Q/pDQicQ5wgcddGYlh4xnslf4J
         OTjGUyCuRu0+BRSoPFLQ2Ohpt58HyWAbbdxUTwxtzNTuq0ZVkIXoOcIb0mPPKQ0oIXed
         JmdLMokKwEm966LRr3fwot8mnoprvD2a8o1MM=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: qhfeng.kernel@gmail.com, Randy Dunlap <rdunlap@xenotime.net>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: [PATCH 6/7] drivers/ata/pata_sis.c: cleanup kernel-doc
Date: Sun, 16 Nov 2008 17:44:13 +0800
User-Agent: sniper-patch-carrier/1.04
Message-ID: <491feb76.04686e0a.739a.3151@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No argument named @deadline in sis_66_cable_detect,
remove it.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index d342366..60a3f00 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -113,7 +113,6 @@ static int sis_133_cable_detect(struct ata_port *ap)
 /**
  *	sis_66_cable_detect	-	check for 40/80 pin
  *	@ap: Port
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection on the UDMA66, UDMA100 and early UDMA133
  *	SiS IDE controllers.

