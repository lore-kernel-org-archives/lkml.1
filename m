Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbYKPJoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbYKPJoU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 04:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYKPJoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 04:44:00 -0500
Received: from ag-out-0708.google.com ([72.14.246.242]:46937 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYKPJn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 04:43:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:bcc:subject:date:user-agent:message-id;
        b=mYK301Z4tQ00WHK/MaVyrBeZY2ttFaq3Fl4mjNWRAMwpqoUTVEl5+vxk2z0C87lvWB
         S2gB7znyUZ3/BEsSYbJNSA6ZASvnwzCPqfUwSDb+Vml2F8I0Eyex9nwWPHk4PN32D/37
         6WFnT+29w+axQD++hggNKeIfyl3TmEAeiI0pU=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: qhfeng.kernel@gmail.com, Randy Dunlap <rdunlap@xenotime.net>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: [PATCH 1/7] drivers/ata/pata_radisys.c: cleanup kernel-doc 
Date: Sun, 16 Nov 2008 17:43:46 +0800
User-Agent: sniper-patch-carrier/1.04
Message-ID: <491feb5b.08486e0a.075a.4c48@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No argument named @isich in radisys_set_dmamode,
remove it.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index 0b0aa45..695d44a 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -81,7 +81,6 @@ static void radisys_set_piomode (struct ata_port *ap, struct ata_device *adev)
  *	radisys_set_dmamode - Initialize host controller PATA DMA timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device to program
- *	@isich: True if the device is an ICH and has IOCFG registers
  *
  *	Set MWDMA mode for device, in host controller PCI config space.
  *

