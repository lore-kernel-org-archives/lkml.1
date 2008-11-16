Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbYKPJok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbYKPJok (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 04:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbYKPJoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 04:44:05 -0500
Received: from mail-gx0-f29.google.com ([209.85.217.29]:46879 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbYKPJoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 04:44:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:bcc:subject:date:user-agent:message-id;
        b=bVYTG99vl0l7HPV4uzYJROVrK0l4SUsmk0fYYlyZwjo2QqYd4KHV0JytVO4mhr1Siw
         fYdHzKC0bEI2yB4lH81umHRAoD7gu696aihQmXKbhK5rp7XOqnNfbgR4V0kBmTOhBPeL
         FOfwKaWNEZI8Ex0ZuX6j3g69Cu0RarmJAhVJg=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: qhfeng.kernel@gmail.com, Randy Dunlap <rdunlap@xenotime.net>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: [PATCH 2/7] drivers/ata/libata-core.c: cleanup kernel-doc
Date: Sun, 16 Nov 2008 17:43:51 +0800
User-Agent: sniper-patch-carrier/1.04
Message-ID: <491feb61.06876e0a.1407.fffff256@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No argument named @tag in ata_qc_new_init,
remove it.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com> 
---
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4214bfb..1e11c5d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4598,7 +4598,6 @@ static struct ata_queued_cmd *ata_qc_new(struct ata_port *ap)
 /**
  *	ata_qc_new_init - Request an available ATA command, and initialize it
  *	@dev: Device from whom we request an available command structure
- *	@tag: command tag
  *
  *	LOCKING:
  *	None.

