Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbYKUVon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbYKUVon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 16:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYKUVoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 16:44:22 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:27113 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbYKUVoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 16:44:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=p08OdA4Qd4H/oSE4loB2kwo5ZY8fqhQfFj3bthb5GlpHSaqZB1liOvcccYQO8fR7+j
         TS2Ctz7SpiqMPP+V6FHY1xab2YlhkeCxPLM56cSIvkjCpvUYupuuC37UlbXzAWSM7ezI
         auCxoiA/RDXnYt3imuP0x3Uo2Bz4zVUjMzt04=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: add SAMSUNG SP0822N with firmware WA100-10 to ivb_list[]
Date: Fri, 21 Nov 2008 22:40:33 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, "Matthias B." <haferfrost@web.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811212240.34153.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should fix kernel.org bug #10225:
http://bugzilla.kernel.org/show_bug.cgi?id=10225

Reported-by: Matthias B. <haferfrost@web.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -610,6 +610,7 @@ static const struct drive_list_entry ivb
 	{ "TSSTcorp CDDVDW SH-S202N"	, "SB01"	},
 	{ "TSSTcorp CDDVDW SH-S202H"	, "SB00"	},
 	{ "TSSTcorp CDDVDW SH-S202H"	, "SB01"	},
+	{ "SAMSUNG SP0822N"		, "WA100-10"	},
 	{ NULL				, NULL		}
 };
 
