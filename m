Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbYAPXRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbYAPXRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494AbYAPXOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:14:31 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:10411 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbYAPXO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:14:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=oSGFIIlfAsTq/+7LL+HanTmUhXMVlz24DPYEaUWCPwMEUlHtm/sSIJwwccSeJxRD84gzoQIMdDyj+EWgn6i+AvntryLo38YG1mj2iC3nXXWgYzyKz6LGTr5FSePaWhEl2HtNR20DcEnXCiIx/GCLQZqoDaK2Ksy36PsQBAYBknk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2008 00:27:09 +0100
Message-Id: <20080116232709.9166.21924.sendpatchset@localhost.localdomain>
In-Reply-To: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
References: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
Subject: [PATCH 09/22] ide: remove incorrect init_gendisk() comment
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    6 ------
 1 file changed, 6 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1182,12 +1182,6 @@ static void drive_release_dev (struct de
 	complete(&drive->gendev_rel_comp);
 }
 
-/*
- * init_gendisk() (as opposed to ide_geninit) is called for each major device,
- * after probing for drives, to allocate partition tables and other data
- * structures needed for the routines in genhd.c.  ide_geninit() gets called
- * somewhat later, during the partition check.
- */
 static void init_gendisk (ide_hwif_t *hwif)
 {
 	unsigned int unit;
