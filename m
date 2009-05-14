Return-Path: <linux-kernel-owner+w=401wt.eu-S1760406AbZENL6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760406AbZENL6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 07:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbZENL61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 07:58:27 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:50843 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbZENL60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 07:58:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=I/TW8r0MkOUWys+sklwYcLFpbOqUGXCsjbkJlsF1UB9KjzL18fkEIoIAZM42lfClop
         g8D5+yUKJdIVQepv/k3yFF6dq/1Fa7uvHkAW43CF2pH3W1gY69nTW4quLyXATYY16/xz
         XQytg1O9MMgdwzar7h4xRobvNiJFeEbWQbS3U=
Message-ID: <4A0C0762.60906@gmail.com>
Date: Thu, 14 May 2009 13:58:26 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] staging: missing parentheses?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing parentheses.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
The original code looks odd, but I am not sure whether my patch is correct.
So please review.

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 43a9d56..a6fbf43 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -460,9 +460,9 @@ static int pcl818_ao_insn_write(struct comedi_device * dev, struct comedi_subdev
 	for (n = 0; n < insn->n; n++) {
 		devpriv->ao_readback[chan] = data[n];
 		outb((data[n] & 0x000f) << 4, dev->iobase +
-			(chan) ? PCL718_DA2_LO : PCL818_DA_LO);
+			(chan ? PCL718_DA2_LO : PCL818_DA_LO));
 		outb((data[n] & 0x0ff0) >> 4, dev->iobase +
-			(chan) ? PCL718_DA2_HI : PCL818_DA_HI);
+			(chan ? PCL718_DA2_HI : PCL818_DA_HI));
 	}
 
 	return n;
