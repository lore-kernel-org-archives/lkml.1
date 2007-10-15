Return-Path: <linux-kernel-owner+w=401wt.eu-S1764256AbXJOWNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764256AbXJOWNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbXJOWNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:13:32 -0400
Received: from havoc.gtf.org ([69.61.125.42]:38055 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbXJOWNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:13:30 -0400
Date: Mon, 15 Oct 2007 18:13:29 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] libata build fix
Message-ID: <20071015221329.GA8778@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


And it becomes obvious I normally do my building and testing on x86-64...

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/pata_cs5536.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

Jeff Garzik (1):
      [libata] pata_cs5536: new API build fix

diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index 21405bf..53070f6 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -239,7 +239,6 @@ static struct scsi_host_template cs5536_sht = {
 };
 
 static struct ata_port_operations cs5536_port_ops = {
-	.port_disable		= ata_port_disable,
 	.set_piomode		= cs5536_set_piomode,
 	.set_dmamode		= cs5536_set_dmamode,
 	.mode_filter		= ata_pci_default_filter,
@@ -269,7 +268,6 @@ static struct ata_port_operations cs5536_port_ops = {
 	.irq_handler		= ata_interrupt,
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
-	.irq_ack		= ata_irq_ack,
 
 	.port_start		= ata_port_start,
 };
