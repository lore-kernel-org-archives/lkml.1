Return-Path: <linux-kernel-owner+w=401wt.eu-S1759390AbXLTBha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390AbXLTBha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758752AbXLTBej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:34:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:11604 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703AbXLTBeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=kKqLvODiB42jlb2xo0TVTmT+RleNK+jAktokCmdct/JREUK947UzcNhMlgiL1sO9yIB2mPRmT3F59n45QlJ0q7vFfDuPKHHllJUpVD7VpoW5nlRSd4Jbj8qFIht4wel5Ba20CRMhk+rRYEaTRrSrcvXkBogi7dlNYRToGPUrHaY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 08/63] ide-cd: fix error message in cdrom_pc_intr()
Date: Thu, 20 Dec 2007 01:57:46 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200157.46753.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1505,7 +1505,7 @@ static ide_startstop_t cdrom_pc_intr (id
 	/* Same drill for reading. */
 	else if ((ireason & 3) == 2) {
 		if (!rq->data) {
-			blk_dump_rq_flags(rq, "cdrom_pc_intr, write");
+			blk_dump_rq_flags(rq, "cdrom_pc_intr, read");
 			goto confused;
 		}
 		/* Transfer the data. */
