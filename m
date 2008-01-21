Return-Path: <linux-kernel-owner+w=401wt.eu-S1762579AbYAUXW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762579AbYAUXW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760713AbYAUXSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:18:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:43432 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760548AbYAUXSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:18:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=pAxWgkuDYYLpqSHfJmDpCgKZLypeTzwa1IIxZVj7l+3BjxKtM/zCcWeyUIz38g1ELQrYttMDEP+u9YHjuO7NLQxOSdLcJlMMatcmr95WakBtp4Px8oKCVvWltFatHXIXefC1Jd1V0TN4XrZpoQOS4RP5cn/a6CEceT9oF1rR0o8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jan 2008 00:31:50 +0100
Message-Id: <20080121233150.30311.27777.sendpatchset@localhost.localdomain>
In-Reply-To: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
References: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
Subject: [PATCH 11/16] ide: unexport SELECT_DRIVE()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -163,8 +163,6 @@ void SELECT_DRIVE (ide_drive_t *drive)
 	HWIF(drive)->OUTB(drive->select.all, IDE_SELECT_REG);
 }
 
-EXPORT_SYMBOL(SELECT_DRIVE);
-
 void SELECT_MASK (ide_drive_t *drive, int mask)
 {
 	if (HWIF(drive)->maskproc)
