Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbYBJXRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbYBJXRc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 18:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756324AbYBJXRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 18:17:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:22234 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915AbYBJXRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 18:17:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=W+5i5gpQLWHtclqRehPHKrI9/K1vXC1V3Uxo7eBh7G4TRriV9ETgraWQDVJpHPuXP0MGy3brRi+ASJEVoiBQt1mdUCOEbIeOw7653dd3wFJ6NtigcoKk2B725jd8gsNGwQ5sM872J6/3LTJsmTIZoQwgGkh69gdWnSctUA4qVus=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ide: fix comment in init_irq()
Date: Mon, 11 Feb 2008 00:23:48 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802110023.50771.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

APUS support is gone...

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1051,7 +1051,7 @@ static int init_irq (ide_hwif_t *hwif)
 		int sa = 0;
 #if defined(__mc68000__)
 		sa = IRQF_SHARED;
-#endif /* __mc68000__ || CONFIG_APUS */
+#endif /* __mc68000__ */
 
 		if (IDE_CHIPSET_IS_PCI(hwif->chipset))
 			sa = IRQF_SHARED;
