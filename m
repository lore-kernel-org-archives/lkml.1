Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbXLFMxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbXLFMxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbXLFMoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:44:14 -0500
Received: from nic2.axis.se ([193.13.178.10]:35787 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649AbXLFMoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:44:12 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <f27c105abe890519bd5d6f57d93ee04952ac0786.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2007 16:30:58 +0100
Subject: [PATCH 33/47] Remove CRISv32 common gpio and nandflash, add mach-fs and mach-a3 as subdirs.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also add board_mmcspi to build if ETRAX_SPI_MMC_BOARD is set.
(Generic MMC SPI implementation)

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/drivers/Makefile |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/Makefile b/arch/cris/arch-v32/drivers/Makefile
index a359cd2..e8c0243 100644
--- a/arch/cris/arch-v32/drivers/Makefile
+++ b/arch/cris/arch-v32/drivers/Makefile
@@ -4,10 +4,11 @@
 
 obj-$(CONFIG_ETRAX_STREAMCOPROC)        += cryptocop.o
 obj-$(CONFIG_ETRAX_AXISFLASHMAP)        += axisflashmap.o
-obj-$(CONFIG_ETRAX_NANDFLASH)           += nandflash.o
-obj-$(CONFIG_ETRAX_GPIO) 	        += gpio.o
+obj-$(CONFIG_ETRAXFS)                   += mach-fs/
+obj-$(CONFIG_CRIS_MACH_ARTPEC3)         += mach-a3/
 obj-$(CONFIG_ETRAX_IOP_FW_LOAD)         += iop_fw_load.o
 obj-$(CONFIG_ETRAX_PCF8563)		+= pcf8563.o
 obj-$(CONFIG_ETRAX_I2C)			+= i2c.o
 obj-$(CONFIG_ETRAX_SYNCHRONOUS_SERIAL)	+= sync_serial.o
 obj-$(CONFIG_PCI)			+= pci/
+obj-$(CONFIG_ETRAX_SPI_MMC_BOARD)	+= board_mmcspi.o
-- 
1.5.3.6.970.gd25430

