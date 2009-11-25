Return-Path: <linux-kernel-owner+w=401wt.eu-S933760AbZKYRTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760AbZKYRTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932272AbZKYRTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:19:40 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:28343 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859AbZKYRJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:09:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=GTiMSCFT3/4L4NeCAoKZ/ERvqDzFr6B/5jwhWWgYCtJJMuEyr8sYltLgPJbLoNQngR
         24SJE2Z3YDqbJS+k8+GnioMNxj//vJE9WL3FU2ZwyOXE7AL32BgkwT+TpK6GW5jk/pcD
         C/QRyJdoykGl0rL3I4KbqkNIfC/akFoHbD7kc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:08:41 +0100
Message-Id: <20091125170841.5446.28051.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 53/86] pata_marvell: fix marvell_pre_reset() documentation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_marvell: fix marvell_pre_reset() documentation

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_marvell.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_marvell.c
===================================================================
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -58,7 +58,7 @@ static int marvell_pata_active(struct pc
 }
 
 /**
- *	marvell_pre_reset	-	check for 40/80 pin
+ *	marvell_pre_reset	-	probe begin
  *	@link: link
  *	@deadline: deadline jiffies for the operation
  *
