Return-Path: <linux-kernel-owner+w=401wt.eu-S1758507AbYLPTee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507AbYLPTee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758040AbYLPTcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:32:33 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:64756 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758020AbYLPTcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:32:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ou0ejDvcIcRtRtyt5s7tlyH1QrXj0o6JDa3UKQM7lt1jA6VnSazW8FeNl7tHhs3eih
         Rz2EM0GBpfcQHBFaJ5NMJbzabKCrUDGVbmX+DzJIi8KbAJtbyJAEmuG4o9P9+PVwtQvX
         oBY4Nh2+A9lbJAsmg6tuirc0RH3OT8MUgw00c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 16 Dec 2008 20:32:23 +0100
Message-Id: <20081216193223.3959.31780.sendpatchset@localhost.localdomain>
In-Reply-To: <20081216193137.3959.70339.sendpatchset@localhost.localdomain>
References: <20081216193137.3959.70339.sendpatchset@localhost.localdomain>
Subject: [PATCH 8/9] ide: unexport ide_wait_not_busy()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: unexport ide_wait_not_busy()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |    3 ---
 1 file changed, 3 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -1216,6 +1216,3 @@ int ide_wait_not_busy(ide_hwif_t *hwif, 
 	}
 	return -EBUSY;
 }
-
-EXPORT_SYMBOL_GPL(ide_wait_not_busy);
-
