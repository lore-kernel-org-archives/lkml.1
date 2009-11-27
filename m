Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbZK0S6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbZK0S6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbZK0S6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:58:41 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:11529 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbZK0S6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:58:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=TiKY+Su7bAll02RmWJAmZSy2cCmKo50gO3/IvCupxmatjOCvq86//uvOwTiHwY7pcx
         LZLUajFLMBcHuoeSBKwKXEQ8F2Une55qXmRPEQ+W2p1uZsUy5YmSXC14PpPywX0GGS2U
         +lCWgfB1Tws3Cgxc22ws2Ar5IYDCnCOO6dqQM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] pata_hpt3x2n: fix overclocked MWDMA0 timing
Date: Fri, 27 Nov 2009 19:56:55 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911271956.55939.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove superfluous timings table entry while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Sergei, XFER_UDMA_5 timing also looks suspicious,
please take a look when you have a minute, thanks.

 drivers/ata/pata_hpt3x2n.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: b/drivers/ata/pata_hpt3x2n.c
===================================================================
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -80,14 +80,13 @@ static struct hpt_clock hpt3x2n_clocks[]
 
 	{	XFER_MW_DMA_2,	0x2c829c62	},
 	{	XFER_MW_DMA_1,	0x2c829c66	},
-	{	XFER_MW_DMA_0,	0x2c829d2c	},
+	{	XFER_MW_DMA_0,	0x2c829d2e	},
 
 	{	XFER_PIO_4,	0x0c829c62	},
 	{	XFER_PIO_3,	0x0c829c84	},
 	{	XFER_PIO_2,	0x0c829ca6	},
 	{	XFER_PIO_1,	0x0d029d26	},
 	{	XFER_PIO_0,	0x0d029d5e	},
-	{	0,		0x0d029d5e	}
 };
 
 /**
