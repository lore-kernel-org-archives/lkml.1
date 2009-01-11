Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbZAKTKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbZAKTKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZAKTK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:10:28 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:63185 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZAKTK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:10:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=Kt6TU1FZTuEhTvIta9t9u4Y7L7fcrWWLeoft9eB05t5CsO2A7Q9TSss5hMYpe7lT9C
         ZXbHwNvh689aCNp+Uh1/aM880b1R5pwbQjIlBSqZDqU4neVgXVgEH8/4+xLeMvAY21DB
         foTTAn7QCLcEzPAFTKcdz3iRtNuC4+Vf9k4YU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 11 Jan 2009 20:11:20 +0100
Message-Id: <20090111191120.17361.69981.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/8] ide: remove superfluous check from ide_proc_port_register_devices()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove superfluous check from ide_proc_port_register_devices()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
just few cleanup patches for pata-2.6 tree (mainly IDE ACPI related)

 drivers/ide/ide-proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -600,7 +600,7 @@ void ide_proc_port_register_devices(ide_
 	int i;
 
 	ide_port_for_each_dev(i, drive, hwif) {
-		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0 || drive->proc)
+		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 			continue;
 
 		drive->proc = proc_mkdir(drive->name, parent);
