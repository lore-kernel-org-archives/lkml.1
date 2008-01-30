Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbYA3IoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbYA3IoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 03:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbYA3Inh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 03:43:37 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:25724 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbYA3Ind (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 03:43:33 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="47621649"
From: Bryan Wu <bryan.wu@analog.com>
To: jgarzik@pobox.com, linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 1/4] [libata] Blackfin pata-bf54x driver: Remove obsolete PM function
Date: Wed, 30 Jan 2008 16:43:25 +0800
Message-Id: <1201682608-22827-2-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201682608-22827-1-git-send-email-bryan.wu@analog.com>
References: <1201682608-22827-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/ata/pata_bf54x.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index a32e3c4..ca62bb7 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1373,10 +1373,6 @@ static struct scsi_host_template bfin_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static const struct ata_port_operations bfin_pata_ops = {
-- 
1.5.3.4
