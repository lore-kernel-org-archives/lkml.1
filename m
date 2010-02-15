Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab0BOPzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 10:55:40 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:53707 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab0BOPzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:55:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JBS0GR7pianVvBOLQMu6UdZvX+F0Wd+TsuWBDfmiRQg19dxrWZpEFMIIBph5hT6OxA
         phzfZeqeZ8fNQUESH6hyn90SEzTipwJrUelTqeXeXFAAIPDkb3cTrVAK6TFQ793BJmSL
         KbJj6nXn/Oyw/LP/8vGf75bY31noAGFo/9vSI=
From: Stefan Schick <stinder21@googlemail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Stefan Schick <steve12123@yahoo.de>
Subject: [PATCH] Staging: comedi: pcmad: fixed a brace coding style issue
Date: Mon, 15 Feb 2010 16:59:58 +0100
Message-Id: <1266249598-29172-1-git-send-email-steve12123@yahoo.de>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue

Signed-off-by: Stefan Schick <steve12123@yahoo.de>
---
 drivers/staging/comedi/drivers/pcmad.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmad.c b/drivers/staging/comedi/drivers/pcmad.c
index acac670..61b9063 100644
--- a/drivers/staging/comedi/drivers/pcmad.c
+++ b/drivers/staging/comedi/drivers/pcmad.c
@@ -113,9 +113,8 @@ static int pcmad_ai_insn_read(struct comedi_device *dev,
 		data[n] = inb(dev->iobase + PCMAD_LSB);
 		data[n] |= (inb(dev->iobase + PCMAD_MSB) << 8);
 
-		if (devpriv->twos_comp) {
+		if (devpriv->twos_comp)
 			data[n] ^= (1 << (this_board->n_ai_bits - 1));
-		}
 	}
 
 	return n;
@@ -168,9 +167,8 @@ static int pcmad_detach(struct comedi_device *dev)
 {
 	printk("comedi%d: pcmad: remove\n", dev->minor);
 
-	if (dev->irq) {
+	if (dev->irq)
 		free_irq(dev->irq, dev);
-	}
 	if (dev->iobase)
 		release_region(dev->iobase, PCMAD_SIZE);
 
-- 
1.6.6.1

