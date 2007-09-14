Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbXINSFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbXINSFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 14:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbXINSFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 14:05:40 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45710 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbXINSFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 14:05:38 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 14 Sep 2007 20:04:49 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] SCSI: trailing whitespace in Kconfig
To: James Bottomley <james.bottomley@steeleye.com>, linux-scsi@vger.kernel.org
cc: Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>,
       Folkert van Heusden <folkert@vanheusden.com>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.913e8b183cdf7888@s5r6.in-berlin.de>
Message-ID: <tkrat.6bd1ddc8d38342e8@s5r6.in-berlin.de>
References: <20070907124800.GP16806@vanheusden.com>
 <p73fy1p9m57.fsf@bingen.suse.de>
 <1189371621.3526.28.camel@localhost.localdomain>
 <20070909210329.GE25798@one.firstfloor.org> <46E46190.6080607@garzik.org>
 <20070912224655.GC3563@stusta.de> <46EAA08F.30703@s5r6.in-berlin.de>
 <20070914151522.GL3563@stusta.de> <46EAAAC1.3050409@s5r6.in-berlin.de>
 <tkrat.d922469e152fe0f3@s5r6.in-berlin.de>
 <tkrat.913e8b183cdf7888@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Applies after patch "SCSI: split Kconfig menu into two".
I didn't want to change whitespace in the portions that this patch
moved from drivers/scsi/Kconfig to drivers/scsi/Kconfig.lowlevel,
hence produced this follow-up.


 drivers/scsi/Kconfig.lowlevel |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.23-rc6/drivers/scsi/Kconfig.lowlevel
===================================================================
--- linux-2.6.23-rc6.orig/drivers/scsi/Kconfig.lowlevel
+++ linux-2.6.23-rc6/drivers/scsi/Kconfig.lowlevel
@@ -252,7 +252,7 @@ config SCSI_DPT_I2O
 	tristate "Adaptec I2O RAID support "
 	depends on !64BIT && SCSI && PCI && VIRT_TO_BUS
 	help
-	  This driver supports all of Adaptec's I2O based RAID controllers as 
+	  This driver supports all of Adaptec's I2O based RAID controllers as
 	  well as the DPT SmartRaid V cards.  This is an Adaptec maintained
 	  driver by Deanna Bonds.  See <file:Documentation/scsi/dpti.txt>.
 
@@ -457,7 +457,7 @@ config SCSI_GDTH
 	---help---
 	  Formerly called GDT SCSI Disk Array Controller Support.
 
-	  This is a driver for RAID/SCSI Disk Array Controllers (EISA/ISA/PCI) 
+	  This is a driver for RAID/SCSI Disk Array Controllers (EISA/ISA/PCI)
 	  manufactured by Intel Corporation/ICP vortex GmbH. It is documented
 	  in the kernel source in <file:drivers/scsi/gdth.c> and
 	  <file:drivers/scsi/gdth.h.>
@@ -491,7 +491,7 @@ config SCSI_GENERIC_NCR5380_MMIO
 	select SCSI_SPI_ATTRS
 	---help---
 	  This is a driver for the old NCR 53c80 series of SCSI controllers
-	  on boards using memory mapped I/O. 
+	  on boards using memory mapped I/O.
 	  It is explained in section 3.8 of the SCSI-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.  If it doesn't work out
 	  of the box, you may have to change some settings in
@@ -1261,7 +1261,7 @@ config SCSI_DEBUG
 	  each with multiple dummy SCSI devices (disks). It defaults to one
 	  host adapter with one dummy SCSI disk. Each dummy disk uses kernel
 	  RAM as storage (i.e. it is a ramdisk). To save space when multiple
-	  dummy disks are simulated, they share the same kernel RAM for 
+	  dummy disks are simulated, they share the same kernel RAM for
 	  their storage. See <http://www.torque.net/sg/sdebug.html> for more
 	  information. This driver is primarily of use to those testing the
 	  SCSI and block subsystems. If unsure, say N.

-- 
Stefan Richter
-=====-=-=== =--= -===-
http://arcgraph.de/sr/

