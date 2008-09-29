Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbYI2Ga4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbYI2Ga4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 02:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYI2GaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 02:30:09 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:8754 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbYI2GaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 02:30:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=swgY6V/pSVoUFkCMhfoE4AW6fmLXmfULIDB8Q47vBJz3gbhwh9dKGZ3tWD6wTfyTrX
         hAttedLVhux6EjfuLZs01PsMp6Espgzcnf253/t5dRZYJdXSQVdlU0NRBNhNNaQnR0/h
         sMaFbVI/ITLp1srzRDkDqKwhw6f1YUsm3idD8=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 2/3] ide-cd: small drive type print fix
Date: Mon, 29 Sep 2008 08:29:58 +0200
Message-Id: <1222669799-6565-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1222669799-6565-1-git-send-email-petkovbb@gmail.com>
References: <1222669799-6565-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 9ffce7f..e41b94d 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1784,7 +1784,7 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 	if ((cdi->mask & CDC_DVD_R) == 0 || (cdi->mask & CDC_DVD_RAM) == 0)
 		printk(KERN_CONT " DVD%s%s",
 				 (cdi->mask & CDC_DVD_R) ? "" : "-R",
-				 (cdi->mask & CDC_DVD_RAM) ? "" : "-RAM");
+				 (cdi->mask & CDC_DVD_RAM) ? "" : "/RAM");
 
 	if ((cdi->mask & CDC_CD_R) == 0 || (cdi->mask & CDC_CD_RW) == 0)
 		printk(KERN_CONT " CD%s%s",
-- 
1.5.5.4

