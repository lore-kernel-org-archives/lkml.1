Return-Path: <linux-kernel-owner+w=401wt.eu-S1755106AbZKHUFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbZKHUFE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:05:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbZKHUFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:05:03 -0500
Received: from khc.piap.pl ([195.187.100.11]:44792 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbZKHUFD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:05:03 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: 16-bit operation of PATA_CS5536?
Date: Sun, 08 Nov 2009 21:05:05 +0100
Message-ID: <m33a4obx5a.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wonder why isn't the PATA CS5536 driver using 32-bit ops.

Does the following make any sense?
It seems to work on my IXP425-based router.

Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>

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
