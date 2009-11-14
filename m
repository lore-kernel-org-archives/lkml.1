Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbZKNOiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbZKNOiR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 09:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbZKNOiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 09:38:17 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:61525 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbZKNOiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 09:38:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=JSut8kKA346hbWL0vMHTz99um+1MKiI37syg/a3+HXHoAXs68j7BotYer0U6cNjAQX
         4HI2D00IpCqchkST+sN5nDxvOjqo4ewby7K9/nYzB6jpo0fpKKjKoV8Ge83gjmW3T6pa
         ILER782Ovau7E7HN8AE2oNDxP2OPv0Q8aEZNI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] libata: prepare for removal of experimental tag on PATA drivers
Date: Sat, 14 Nov 2009 15:37:19 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911141537.19068.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Push experimental tags to host drivers that still need it so we can
remove the "global" experimental tag for PATA drivers.

I hear that some issues are being worked on but the patch reflects
the current situation and we can trivially update status of affected
host drivers after new fixes are merged.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/Kconfig |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: b/drivers/ata/Kconfig
===================================================================
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -230,8 +230,8 @@ config PATA_ACPI
 	  otherwise unsupported hardware.
 
 config PATA_ALI
-	tristate "ALi PATA support"
-	depends on PCI
+	tristate "ALi PATA support (Experimental)"
+	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the ALi ATA interfaces
 	  found on the many ALi chipsets.
@@ -293,8 +293,8 @@ config PATA_CMD640_PCI
 	  If unsure, say N.
 
 config PATA_CMD64X
-	tristate "CMD64x PATA support"
-	depends on PCI
+	tristate "CMD64x PATA support (Experimental)"
+	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the CMD64x series chips
 	  except for the CMD640.
@@ -574,8 +574,8 @@ config PATA_PCMCIA
 	  If unsure, say N.
 
 config PATA_PDC_OLD
-	tristate "Older Promise PATA controller support"
-	depends on PCI
+	tristate "Older Promise PATA controller support (Experimental)"
+	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the Promise 20246, 20262, 20263,
 	  20265 and 20267 adapters.
@@ -660,8 +660,8 @@ config PATA_SIL680
 	  If unsure, say N.
 
 config PATA_SIS
-	tristate "SiS PATA support"
-	depends on PCI
+	tristate "SiS PATA support (Experimental)"
+	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for SiS PATA controllers
 
