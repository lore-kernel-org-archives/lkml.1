Return-Path: <linux-kernel-owner+w=401wt.eu-S1763335AbYBHAcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763335AbYBHAcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762788AbYBHAax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:30:53 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:45438 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762329AbYBHAag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:30:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=AHirhp9nY7D24/vGZlb8VLFkPN3rXurtqc8C7X9hIGPE6tFTShSVKHL+Cf/vvTwQXkolDGRm4UairOT8cuKvB16zJmvuV4/4pyCyS9iq1u65mWS745Jgs4aQCtYM5Ag/8doAELN3LdlBveLvQnRvCi/qft5z4Ug1wMFzYLHIdHU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 08 Feb 2008 01:44:48 +0100
Message-Id: <20080208004448.17746.71220.sendpatchset@localhost.localdomain>
In-Reply-To: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/18] ide-acpi: add missing drive->acpidata zeroing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-acpi.c |    2 ++
 1 file changed, 2 insertions(+)

Index: b/drivers/ide/ide-acpi.c
===================================================================
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -710,6 +710,8 @@ void ide_acpi_port_init_devices(ide_hwif
 	for (i = 0; i < MAX_DRIVES; i++) {
 		drive = &hwif->drives[i];
 
+		memset(drive->acpidata, 0, sizeof(*drive->acpidata));
+
 		if (!drive->present)
 			continue;
 
