Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbZAFSeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbZAFSeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbZAFSej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:34:39 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:59930 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZAFSei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:34:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=utE7PJXZeWhfE6iwJYB6ijfZXmU0CqFsupE8mCF3bQ2MJJ81Qq6GaQh6Wocts4KruP
         WqQ9ZBc7KyJ5UY5h9DR5Ygjqd3i2jZHoxAP7X80JuMnpkRLKO5P5sa2a+trvoCm9giS+
         l2gfDhenOtNt9aT12SGdRlnaLmsdTBgXjaOSs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 06 Jan 2009 19:35:20 +0100
Message-Id: <20090106183520.21193.63704.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/9] via82cxxx: fix cable warning message
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] via82cxxx: fix cable warning message

Remove reference to the removed old-style kernel parameter.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
minor fixes/cleanups for pata-2.6 tree

 drivers/ide/via82cxxx.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/drivers/ide/via82cxxx.c
===================================================================
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -432,8 +432,6 @@ static int __devinit via_init_one(struct
 	if (via_clock < 20000 || via_clock > 50000) {
 		printk(KERN_WARNING DRV_NAME ": User given PCI clock speed "
 			"impossible (%d), using 33 MHz instead.\n", via_clock);
-		printk(KERN_WARNING DRV_NAME ": Use ide0=ata66 if you want "
-			"to assume 80-wire cable.\n");
 		via_clock = 33333;
 	}
 
