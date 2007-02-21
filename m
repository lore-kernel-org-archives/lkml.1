Return-Path: <linux-kernel-owner+w=401wt.eu-S1751250AbXBUOdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250AbXBUOdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 09:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbXBUOdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 09:33:47 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34126 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751250AbXBUOdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 09:33:46 -0500
Date: Wed, 21 Feb 2007 15:37:29 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Komuro <komurojun-mbn@nifty.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG]  PATA_PCMCIA does not work
Message-ID: <20070221153729.5eab83b6@lxorguk.ukuu.org.uk>
In-Reply-To: <20070218110914.888de729.komurojun-mbn@nifty.com>
References: <20061217212752.d93816b4.komurojun-mbn@nifty.com>
	<20061217040222.GD17561@ftp.linux.org.uk>
	<20070211101537.e40fa309.komurojun-mbn@nifty.com>
	<20070211114013.65b2be2c.komurojun-mbn@nifty.com>
	<20070218110914.888de729.komurojun-mbn@nifty.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Does this fix the oops ?

Alan


diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ata/pata_pcmcia.c linux-2.6.20-mm2/drivers/ata/pata_pcmcia.c
--- linux.vanilla-2.6.20-mm2/drivers/ata/pata_pcmcia.c	2007-02-20 13:37:58.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ata/pata_pcmcia.c	2007-02-21 14:06:58.792707976 +0000
@@ -308,7 +342,6 @@
 		if (info->ndev) {
 			struct ata_host *host = dev_get_drvdata(dev);
 			ata_host_detach(host);
-			dev_set_drvdata(dev, NULL);
 		}
 		info->ndev = 0;
 		pdev->priv = NULL;



