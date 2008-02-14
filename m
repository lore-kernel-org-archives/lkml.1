Return-Path: <linux-kernel-owner+w=401wt.eu-S934607AbYBNFTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934607AbYBNFTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 00:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765010AbYBNFOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 00:14:49 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:7963 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763767AbYBNFOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 00:14:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UlT+cN/0xF2YdENEP59/frWUwGJZtDJUjbtfhW/14clw+C/z94t+Cl1pA8kfFIFv/gAYR0lxTx33WttqCfm1trVwli64MuSfLWOkTCbBTLmmBTkoALAM5cMcZY34EUu+xNA9m3Wwg/fWONlogIzqlO+bArSG5bGeezTMfiSZvlY=
Subject: [PATCH 10/11] ata: fix sparse warning in pata_acpi.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
References: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 21:14:31 -0800
Message-Id: <1202966071.2748.26.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/ata/pata_acpi.c:80:2: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/ata/pata_acpi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index 244098a..bdc3b9d 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -77,8 +77,8 @@ static int pacpi_cable_detect(struct ata_port *ap)
 
 static void pacpi_error_handler(struct ata_port *ap)
 {
-	return ata_bmdma_drive_eh(ap, pacpi_pre_reset, ata_std_softreset,
-				  NULL, ata_std_postreset);
+	ata_bmdma_drive_eh(ap, pacpi_pre_reset, ata_std_softreset, NULL,
+			   ata_std_postreset);
 }
 
 /**
-- 
1.5.4.1.1278.gc75be


