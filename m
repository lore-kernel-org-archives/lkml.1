Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbXE0PGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbXE0PGe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 11:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbXE0PGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 11:06:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40036 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbXE0PGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 11:06:23 -0400
Message-ID: <46599E6B.1000209@pobox.com>
Date: Sun, 27 May 2007 11:06:19 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux v2.6.22-rc3
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org> <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>
In-Reply-To: <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------000202040806080305020907"
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000202040806080305020907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Gregor Jasny wrote:
> Hi,
> 
> 2007/5/26, Linus Torvalds <torvalds@linux-foundation.org>:
>> What more could you possibly want? Some ATA updates? USB suspend problem
> 
> 22-rc3 broke the CDROM in my Dell notebook.  After I've switched to
> libata som time ago, I've got some delays/timeouts during boot [1].
> But the drive works as expected. With 2.6.22-rc3 I've got the
> following messages during bootup:

Does the attached patch fix things?

Tejun just posted the upstream-ready version earlier today.

	Jeff




--------------000202040806080305020907
Content-Type: message/rfc822;
 name="Attached Message"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Attached Message"

X-Account-Key: account3
Return-path: <linux-ide-owner@vger.kernel.org>
Envelope-to: jeff@garzik.org
Delivery-date: Sun, 27 May 2007 13:10:58 +0000
Received: from srv1.dvmed.net ([207.234.209.181])
	by mail.dvmed.net with esmtps (Exim 4.63 #1 (Red Hat Linux))
	id 1HsIWQ-00038t-SZ
	for jeff@garzik.org; Sun, 27 May 2007 13:10:58 +0000
Received: from vger.kernel.org ([209.132.176.167])
	by srv1.dvmed.net with esmtp (Exim 4.63 #1 (Red Hat Linux))
	id 1HsIWP-0001Es-Ik
	for jeff@garzik.org; Sun, 27 May 2007 13:10:58 +0000
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbXE0NK4 (ORCPT <rfc822;jeff@garzik.org>);
	Sun, 27 May 2007 09:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbXE0NK4
	(ORCPT <rfc822;linux-ide-outgoing>); Sun, 27 May 2007 09:10:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:25992 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbXE0NKz (ORCPT
	<rfc822;linux-ide@vger.kernel.org>); Sun, 27 May 2007 09:10:55 -0400
Received: by nz-out-0506.google.com with SMTP id n1so667236nzf
        for <linux-ide@vger.kernel.org>; Sun, 27 May 2007 06:10:54 -0700 (PDT)
DKIM-Signature: a=rsa-sha1; c=relaxed/relaxed;
        d=gmail.com; s=beta;
        h=domainkey-signature:received:received:received:message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=YtSekfwfp+Jatf0sOaVdZjv/Ned+loYzFeBU3LabAAaJG2iZf8tgImZFbGzkHRNOqCWrczJxxuDjIlsBmb80SIiMTVrWvuTU5rAL8W5rBiaqjl2jMJeqa1UEq6y0CevR9cgd9LqAHEx13jTw5Eembgbxc7sj1H6Wqw5DGumMXTs=
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=Z7KUP3srAovAPkzYg3cJU3gWeL1URJApqMqeN7haDl2mEIgh4yIMKoQ/RBawtTLC+wibZ5QcbsF1WiwLROQkrhYvq4puZ8HRyTuq/rmX2b23frM285AVgwhz0MKqk2+vwJXYyOmJjVhnZEf6qy1VQbgfNofNxr43RpQFVSNO2z8=
Received: by 10.114.193.1 with SMTP id q1mr2416899waf.1180271453691;
        Sun, 27 May 2007 06:10:53 -0700 (PDT)
Received: from htj.dyndns.org ( [221.139.199.126])
        by mx.google.com with ESMTP id y11sm7419326pod.2007.05.27.06.10.51;
        Sun, 27 May 2007 06:10:52 -0700 (PDT)
Received: from [10.10.101.146] (charybdis-ext.suse.de [195.135.221.2])
	(using SSLv3 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: tj@htj.dyndns.org)
	by htj.dyndns.org (Postfix) with ESMTP id A05B423D4B8A;
	Sun, 27 May 2007 22:10:45 +0900 (KST)
Message-ID: <46598350.6030403@gmail.com>
Date: Sun, 27 May 2007 15:10:40 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>,
	IDE/ATA development list <linux-ide@vger.kernel.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] libata: always use polling SETXFER
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-ide-owner@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-ide@vger.kernel.org
X-Spam-Score: -2.6 (--)
X-Spam-Report: SpamAssassin version 3.1.8 on srv1.dvmed.net summary:
	Content analysis details:   (-2.6 points, 5.0 required)

Several people have reported LITE-ON LTR-48246S detection failed
because SETXFER fails.  It seems the device raises IRQ too early after
SETXFER.  This is controller independent.  The same problem has been
reported for different controllers.

So, now we have pata_via where the controller raises IRQ before it's
ready after SETXFER and a device which does similar thing.  This patch
makes libata always execute SETXFER via polling.  As this only happens
during EH, performance impact is nil.  Setting ATA_TFLAG_POLLING is
also moved from issue hot path to ata_dev_set_xfermode() - the only
place where SETXFER can be issued.

Note that ATA_TFLAG_POLLING applies only to drivers which implement
SFF TF interface and use libata HSM.  More advanced controllers ignore
the flag.  This doesn't matter for this fix as SFF TF controllers are
the problematic ones.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 drivers/ata/libata-core.c |   13 ++++---------
 drivers/ata/pata_via.c    |   12 ++++++------
 include/linux/libata.h    |    1 -
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3ca9c61..4d6de65 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3932,10 +3932,13 @@ static unsigned int ata_dev_set_xfermode
 	/* set up set-features taskfile */
 	DPRINTK("set features - xfer mode\n");
 
+	/* Some controllers and ATAPI devices show flaky interrupt
+	 * behavior after setting xfer mode.  Use polling instead.
+	 */
 	ata_tf_init(dev, &tf);
 	tf.command = ATA_CMD_SET_FEATURES;
 	tf.feature = SETFEATURES_XFER;
-	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE | ATA_TFLAG_POLLING;
 	tf.protocol = ATA_PROT_NODATA;
 	tf.nsect = dev->xfer_mode;
 
@@ -5413,14 +5416,6 @@ unsigned int ata_qc_issue_prot(struct at
 		}
 	}
 
-	/* Some controllers show flaky interrupt behavior after
-	 * setting xfer mode.  Use polling instead.
-	 */
-	if (unlikely(qc->tf.command == ATA_CMD_SET_FEATURES &&
-		     qc->tf.feature == SETFEATURES_XFER) &&
-	    (ap->flags & ATA_FLAG_SETXFER_POLLING))
-		qc->tf.flags |= ATA_TFLAG_POLLING;
-
 	/* select the device */
 	ata_dev_select(ap, qc->dev->devno, 1, 0);
 
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index a8462f1..63eca29 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -452,7 +452,7 @@ static int via_init_one(struct pci_dev *
 	/* Early VIA without UDMA support */
 	static const struct ata_port_info via_mwdma_info = {
 		.sht = &via_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.port_ops = &via_port_ops
@@ -460,7 +460,7 @@ static int via_init_one(struct pci_dev *
 	/* Ditto with IRQ masking required */
 	static const struct ata_port_info via_mwdma_info_borked = {
 		.sht = &via_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.port_ops = &via_port_ops_noirq,
@@ -468,7 +468,7 @@ static int via_init_one(struct pci_dev *
 	/* VIA UDMA 33 devices (and borked 66) */
 	static const struct ata_port_info via_udma33_info = {
 		.sht = &via_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x7,
@@ -477,7 +477,7 @@ static int via_init_one(struct pci_dev *
 	/* VIA UDMA 66 devices */
 	static const struct ata_port_info via_udma66_info = {
 		.sht = &via_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x1f,
@@ -486,7 +486,7 @@ static int via_init_one(struct pci_dev *
 	/* VIA UDMA 100 devices */
 	static const struct ata_port_info via_udma100_info = {
 		.sht = &via_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x3f,
@@ -495,7 +495,7 @@ static int via_init_one(struct pci_dev *
 	/* UDMA133 with bad AST (All current 133) */
 	static const struct ata_port_info via_udma133_info = {
 		.sht = &via_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x7f,	/* FIXME: should check north bridge */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 85f7b1b..a6a3113 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -171,7 +171,6 @@ enum {
 	ATA_FLAG_SKIP_D2H_BSY	= (1 << 12), /* can't wait for the first D2H
 					      * Register FIS clearing BSY */
 	ATA_FLAG_DEBUGMSG	= (1 << 13),
-	ATA_FLAG_SETXFER_POLLING= (1 << 14), /* use polling for SETXFER */
 	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
 	ATA_FLAG_NO_IORDY	= (1 << 16), /* controller lacks iordy */
 	ATA_FLAG_ACPI_SATA	= (1 << 17), /* need native SATA ACPI layout */

-
To unsubscribe from this list: send the line "unsubscribe linux-ide" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


--------------000202040806080305020907--
