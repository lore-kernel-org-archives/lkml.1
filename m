Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbZAOUMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbZAOUMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765966AbZAOUAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:60426 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765708AbZAOUAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=OJe9ziXxQ68cfp0l3EtSnRVtEusOXwsArVIDZNfePhw+rc1UxDh6iNdZkidgrI/j7O
         RJvekIUTxo+AXMU8uJM0duUAF37HtPLra6dYRmHlhXE3gaIVGFzYRy8JpktLXsHVfjFV
         KucBdbIh1I9H56iMmrDyfKAQXDxSFkBWB01SM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 15 Jan 2009 21:00:45 +0100
Message-Id: <20090115200045.17294.34572.sendpatchset@localhost.localdomain>
In-Reply-To: <20090115200032.17294.84745.sendpatchset@localhost.localdomain>
References: <20090115200032.17294.84745.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/9] ide: unexport ide_devset_execute()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: unexport ide_devset_execute()

There are no modular ide_devset_execute() users left so unexport it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c |    1 -
 1 file changed, 1 deletion(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -510,7 +510,6 @@ int ide_devset_execute(ide_drive_t *driv
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(ide_devset_execute);
 
 static ide_startstop_t ide_special_rq(ide_drive_t *drive, struct request *rq)
 {
