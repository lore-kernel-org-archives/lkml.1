Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbYHSSmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbYHSSmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbYHSSmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:42:01 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:23913 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbYHSSmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:42:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jpzqUML/uATUdt6vZ5GtBeh9448LywtOlOwXMOmo5XDux/Erx+W/hr9YR8ZuKAmXU9
         HFAGjQ8q4RUvo8jFdZq/DNSWE/VRPscOzEf/NJNtbiubyEp0MvfYDy+NByGzurfbR5c0
         nrJi/vbrk1L6GpsJer4YS/H0Y0ao1iV4pLSto=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 19 Aug 2008 20:39:41 +0200
Message-Id: <20080819183941.16469.88841.sendpatchset@localhost.localdomain>
In-Reply-To: <20080819183934.16469.69799.sendpatchset@localhost.localdomain>
References: <20080819183934.16469.69799.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/6] ide-cd: no need to zero drive->special.all
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1882,8 +1882,6 @@ static int ide_cdrom_setup(ide_drive_t *
 	if (!drive->queue->unplug_delay)
 		drive->queue->unplug_delay = 1;
 
-	drive->special.all	= 0;
-
 	drive->atapi_flags = IDE_AFLAG_MEDIA_CHANGED | IDE_AFLAG_NO_EJECT |
 		       ide_cd_flags(id);
 
