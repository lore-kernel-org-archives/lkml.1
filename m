Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbZBOT2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbZBOT2Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 14:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbZBOT2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 14:28:17 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:44584 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbZBOT2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 14:28:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=o0wjs7TBIP6SaRDnIc2hgzcPqxFtuJsIAiD1ea0XWmOJq3HYlNNlwkP1HvQFZSY+LY
         t1JosxnY/HryHPofRtRo9M7t880KmekYqj9lMbgPix+4AxpHpUeAb67juGmFlSh9xtRx
         o/Fky3Nvfj7a1k7gAmRSXUHx53sVEzvys8thc=
Message-ID: <49986CCF.4010005@gmail.com>
Date: Sun, 15 Feb 2009 20:28:15 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] staging: &&/|| typo
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only error out on unexpected fifo size.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 65d5242..6c7d543 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -1234,7 +1234,7 @@ static int rtd520_probe_fifo_depth(comedi_device *dev)
 		return -EIO;
 	}
 	RtdAdcClearFifo(dev);
-	if(fifo_size != 0x400 || fifo_size != 0x2000)
+	if(fifo_size != 0x400 && fifo_size != 0x2000)
 	{
 		rt_printk("\ncomedi: %s: unexpected fifo size of %i, expected 1024 or 8192.\n",
 			DRV_NAME, fifo_size);
