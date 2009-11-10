Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbZKJX6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbZKJX6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 18:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758660AbZKJX6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 18:58:13 -0500
Received: from khc.piap.pl ([195.187.100.11]:42956 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186AbZKJX6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 18:58:12 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: ATA: Make CS5536 PATA driver use 32-bit BM DMA template instead of 16-bit.
Date: Wed, 11 Nov 2009 00:58:16 +0100
Message-ID: <m3my2u0w6f.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested on IXP425 + CS5536.

Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>

diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index 88a7933..0898213 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -232,7 +232,7 @@ static struct scsi_host_template cs5536_sht = {
 };
 
 static struct ata_port_operations cs5536_port_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma32_port_ops,
 	.cable_detect		= cs5536_cable_detect,
 	.set_piomode		= cs5536_set_piomode,
 	.set_dmamode		= cs5536_set_dmamode,

-- 
Krzysztof Halasa
