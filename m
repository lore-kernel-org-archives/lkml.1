Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbYL2TFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbYL2TFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 14:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbYL2TEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 14:04:16 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:54079 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbYL2TEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 14:04:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=apEZhXRDJPyIlmwScEgum0FNHbLJZ//6gWX8QDjZFZMXJwIuS6j7VBoSYxmknKMGZA
         tXfrhT3Pj6lWXdRh0bXWIn2Qk/PrGhnZG5a643rGPzoej1QHIuL8c8LBs5wVvqBx7jC8
         ModPa/56cAdyALtL5JWBJVTRpUXak8foXdW7U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 29 Dec 2008 20:04:35 +0100
Message-Id: <20081229190435.1020.45092.sendpatchset@localhost.localdomain>
In-Reply-To: <20081229190415.1020.43119.sendpatchset@localhost.localdomain>
References: <20081229190415.1020.43119.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/6] ide: struct ide_atapi_pc - remove unused fields and update documentation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: struct ide_atapi_pc - remove unused fields and update documentation

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/ide.h |    4 ----
 1 file changed, 4 deletions(-)

Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -426,13 +426,9 @@ struct ide_atapi_pc {
 	struct idetape_bh *bh;
 	char *b_data;
 
-	/* idescsi only for now */
 	struct scatterlist *sg;
 	unsigned int sg_cnt;
 
-	struct scsi_cmnd *scsi_cmd;
-	void (*done) (struct scsi_cmnd *);
-
 	unsigned long timeout;
 };
 
