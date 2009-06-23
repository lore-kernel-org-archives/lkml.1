Return-Path: <linux-kernel-owner+w=401wt.eu-S1758586AbZFWVc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586AbZFWVc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758018AbZFWVcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:32:32 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:35567 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbZFWVca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=VhdcQH5wpWawHlEf82yr6z/7sADiz4iTqpJAEZcd7uQoU2E9ni9gqEYLLDPnyWmgbN
         Ww/veIO8lQPqdp1ZChjbw7FDfThOFGw7KmJcH/DzGj1mQ3B2Zc4FWuwNgS5fiB77b0/o
         l1kgQYIjrExvLQ+0AcIKEgsr8iDZIxPgh2df0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: [patch 1/6] ide: add QUANTUM FIREBALLct20 30 with firmware APL.090 to ivb_list[]
Date: Tue, 23 Jun 2009 23:24:37 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090623-11043-g1684859-dirty; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906232324.37615.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: add QUANTUM FIREBALLct20 30 with firmware APL.090 to ivb_list[]

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
This disk supports UDMA modes > 2.  According to the old bugreport it needs
forced cable detection when using 80-wire cable and id dump suggested that
ivb quirk should be used to fix the problem.  Unfortunately I never received
any feedback about the patch from the bugreporter.

 drivers/ide/ide-iops.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -210,6 +210,7 @@ EXPORT_SYMBOL_GPL(ide_in_drive_list);
  */
 static const struct drive_list_entry ivb_list[] = {
 	{ "QUANTUM FIREBALLlct10 05"	, "A03.0900"	},
+	{ "QUANTUM FIREBALLlct20 30"	, "APL.0900"	},
 	{ "TSSTcorp CDDVDW SH-S202J"	, "SB00"	},
 	{ "TSSTcorp CDDVDW SH-S202J"	, "SB01"	},
 	{ "TSSTcorp CDDVDW SH-S202N"	, "SB00"	},
