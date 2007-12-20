Return-Path: <linux-kernel-owner+w=401wt.eu-S1758362AbXLTBxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362AbXLTBxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759305AbXLTBhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:37:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:11731 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758889AbXLTBeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=UAk1RTk88/vbsGxLcyiqnK5oWEmkBCrZw265C3QcnORfqNveBhIqd+pGh4Dk8lGjteb+UAUokdXK8k+NmCEqFFbV8uBtebWw5s7k3SlPdeOlevMhSePxhADEB5jVHwEQFDD3dJJwomtCsEYHyGN6oPX6+3Y6mQRHoUKj+MS/Ywc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 42/63] ide-cd: coding style fixes for cdrom_get_toc_entry()
Date: Thu, 20 Dec 2007 02:25:00 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200225.00426.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a preparation to move code handling cdrom.c IOCTLs out of ide-cd.c.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1993,11 +1993,13 @@ static int cdrom_get_toc_entry(ide_drive
 
 	/* Check validity of requested track number. */
 	ntracks = toc->hdr.last_track - toc->hdr.first_track + 1;
-	if (toc->hdr.first_track == CDROM_LEADOUT) ntracks = 0;
+
+	if (toc->hdr.first_track == CDROM_LEADOUT)
+		ntracks = 0;
+
 	if (track == CDROM_LEADOUT)
 		*ent = &toc->ent[ntracks];
-	else if (track < toc->hdr.first_track ||
-		 track > toc->hdr.last_track)
+	else if (track < toc->hdr.first_track || track > toc->hdr.last_track)
 		return -EINVAL;
 	else
 		*ent = &toc->ent[track - toc->hdr.first_track];
