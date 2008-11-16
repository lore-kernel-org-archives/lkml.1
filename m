Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbYKPJo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbYKPJo4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 04:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYKPJoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 04:44:10 -0500
Received: from mail-gx0-f29.google.com ([209.85.217.29]:46879 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbYKPJoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 04:44:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:bcc:subject:date:user-agent:message-id;
        b=ROhquKplJ2VugwSeLL2nwK3Ww/kQ4DYiwJtX/4hkp8BD+EA7Rah6FMS4PsqTmxt9DC
         UI4SXB/YkqyFBeFZDtQJnls++i6WKz57BHZoajJ+KBv46r3whyEbxHzRtBqEJ+pFW5mo
         CxUDW1kfLF/zmL8DocjQUu208wXMqOn+RFDCk=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: qhfeng.kernel@gmail.com, Randy Dunlap <rdunlap@xenotime.net>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: [PATCH 3/7] drivers/ata/pata_oldpiix.c: cleanup kernel-doc
Date: Sun, 16 Nov 2008 17:43:57 +0800
User-Agent: sniper-patch-carrier/1.04
Message-ID: <491feb66.160d6e0a.586d.fffff912@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No argument named @isich in oldpiix_set_dmamode,
remove it.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index c0dbc46..2c1a91c 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -116,7 +116,6 @@ static void oldpiix_set_piomode (struct ata_port *ap, struct ata_device *adev)
  *	oldpiix_set_dmamode - Initialize host controller PATA DMA timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device to program
- *	@isich: True if the device is an ICH and has IOCFG registers
  *
  *	Set MWDMA mode for device, in host controller PCI config space.
  *

