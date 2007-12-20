Return-Path: <linux-kernel-owner+w=401wt.eu-S1760114AbXLTBjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114AbXLTBjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758932AbXLTBe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:34:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:11752 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090AbXLTBeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Kf0z3xWgWm++NBvAgiuW32gmyW70W/Xk0QN29/4rMLdBIv76tzI1F1sez6eTeSPXkj+gZRZAIJ/08hl8achBWNqUCVW5vJzE7jsVHduDkJV10N4YZ7suJTc4FBF6WrSTbAZ4WDP5AUJkQf/dWP67+49xz++QsIObHWUQV3kznSY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 18/63] ide-cd: remove dead code from cdrom_pc_intr()
Date: Thu, 20 Dec 2007 02:05:51 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200205.51585.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    7 -------
 1 file changed, 7 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1201,13 +1201,6 @@ static ide_startstop_t cdrom_pc_intr (id
 		if (rq->data_len == 0)
 			cdrom_end_request(drive, 1);
 		else {
-			/* Comment this out, because this always happens 
-			   right after a reset occurs, and it is annoying to 
-			   always print expected stuff.  */
-			/*
-			printk ("%s: cdrom_pc_intr: data underrun %d\n",
-				drive->name, pc->buflen);
-			*/
 			rq->cmd_flags |= REQ_FAILED;
 			cdrom_end_request(drive, 0);
 		}
