Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbYIGWRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbYIGWRy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbYIGWQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:16:54 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:54949 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbYIGWQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:16:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=vru3ynV1qPsjgSlSB6iP1OqDcn/Hs9bsFCe5zSqCaRKpt7JC3sBUVsgSFE0IvGfquZ
         MPo3r2hoRAVj/Gkr0IONq/p+egzpRc5UkdM4o4eDFYoRtgJLnrX91NRqnCeigHlxMfzS
         3eQYOG7HuaRxukS/BkiE/lCp3o9YzKTcv3Y/8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2008 00:14:44 +0200
Message-Id: <20080907221444.24285.64157.sendpatchset@localhost.localdomain>
In-Reply-To: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
References: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
Subject: [PATCH 03/18] ide-floppy: use alloc_disk_node()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -788,7 +788,7 @@ static int ide_floppy_probe(ide_drive_t 
 		goto failed;
 	}
 
-	g = alloc_disk(1 << PARTN_BITS);
+	g = alloc_disk_node(1 << PARTN_BITS, hwif_to_node(drive->hwif));
 	if (!g)
 		goto out_free_floppy;
 
