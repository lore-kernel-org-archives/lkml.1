Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbYL2TEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbYL2TEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 14:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbYL2TEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 14:04:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:63827 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbYL2TEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 14:04:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=aB7eK05KqzpYFlSx2vqke0aWZfdj2chn9nQoWAlvmr3aEAgpuRcdd+pipKaN00wUSb
         uzOWPFBO18EFlIUlVRlqchRMVcggMObBR9SkaSf7ejB5A3Ti1MLXG/VxphQkZW0hsxo8
         OasUJlJyvG+eM5taabPy3oXHlv5p29cYZ7jIM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 29 Dec 2008 20:04:29 +0100
Message-Id: <20081229190429.1020.49267.sendpatchset@localhost.localdomain>
In-Reply-To: <20081229190415.1020.43119.sendpatchset@localhost.localdomain>
References: <20081229190415.1020.43119.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/6] ide: remove superfluous hwif variable assignment from ide_timer_expiry()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove superfluous hwif variable assignment from ide_timer_expiry()

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c |    1 -
 1 file changed, 1 deletion(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -946,7 +946,6 @@ void ide_timer_expiry (unsigned long dat
 			 * globally mask the specific IRQ:
 			 */
 			spin_unlock(&hwif->lock);
-			hwif = drive->hwif;
 			/* disable_irq_nosync ?? */
 			disable_irq(hwif->irq);
 			/* local CPU only,
