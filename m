Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbZKTXqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbZKTXqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 18:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbZKTXqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 18:46:13 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:46337 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbZKTXqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 18:46:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MZMewo/sksv8MAXMjCNbcd5NbBL3uVZShHHhWhUqptcS7NgOKrD5h4+oytNaLutr3Z
         GUOl+PEJp9QqmdeXmQqKWundBf1hhxtK0SWG8qBli8HYUfd6IgDduoVw5uuWASRIcHl6
         /8MH+D7V0kGU2o7pLDg3ZwhF1YfMUFeMGh0+I=
From: Bruce Beare <bbeare1@gmail.com>
To: gregkh@suse.de
Cc: wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, Bruce Beare <bbeare1@gmail.com>
Subject: [PATCH 2/3] Cleanup: Remove unneeded braces (cleanup warning message)
Date: Fri, 20 Nov 2009 15:46:10 -0800
Message-Id: <1258760771-24311-3-git-send-email-bbeare1@gmail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258760771-24311-2-git-send-email-bbeare1@gmail.com>
References: <1258760771-24311-1-git-send-email-bbeare1@gmail.com>
 <1258760771-24311-2-git-send-email-bbeare1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bruce Beare <bbeare1@gmail.com>
---
 drivers/staging/comedi/drivers/pcmad.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmad.c b/drivers/staging/comedi/drivers/pcmad.c
index 202bfd4..787aea2 100644
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
1.6.2.5

