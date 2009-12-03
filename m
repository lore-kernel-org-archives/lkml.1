Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbZLCH4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbZLCH4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 02:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbZLCH4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 02:56:47 -0500
Received: from havoc.gtf.org ([69.61.125.42]:55518 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbZLCH4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 02:56:46 -0500
Date: Thu, 3 Dec 2009 02:56:53 -0500
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: What's in libata-dev.git?
Message-ID: <20091203075653.GA30612@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the contents of the recently-rebased "upstream" branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

This is what will get sent RSN for 2.6.33.

I am hoping we can also get Bart's big chunk o patches in for 2.6.33,
too?

Alan Cox (6):
      pata_via: Blacklist some combinations of Transcend Flash and via
      pata_sis: Implement MWDMA for the UDMA 133 capable chips
      pata_cmd64x: implement serialization as per notes
      [libata] PATA: Update experimental tags
      pata_ali: Fix regression with old devices
      pata_piccolo: Driver for old Toshiba chipsets

Bartlomiej Zolnierkiewicz (5):
      pata_hpt37x: add proper cable detection methods
      pata_hpt37x: unify ->pre_reset methods
      pata_hpt3x2n: fix cable detection
      pata_hpt{37x,3x2n}: add debounce delay to cable detection methods
      libata: add comment documenting PIO latency issues on UP

Benjamin Herrenschmidt (1):
      libata/sff: Use ops->bmdma_stop instead of ata_bmdma_stop()

Christoph Hellwig (1):
      libata: add translation for SCSI WRITE SAME (aka TRIM support)

Jiri Slaby (1):
      pata_via: fix double put on isa bridge

Krzysztof Halasa (1):
      pata_cs5536: use 32-bit BM DMA template instead of 16-bit.

Mark Nelson (1):
      ahci: let users know that Promise PDC42819 support is limited to SATA devices

Matthew Garrett (1):
      ata: Don't require newlines for link_power_management_policy

Otavio Salvador (1):
      pata-it821x: use PCI_DEVICE_ID_RDC_D1010 define

Robert Hancock (1):
      libata: remove experimental tag on PATA drivers

Sergei Shtylyov (3):
      pata_hpt{37x|3x2n}: fix timing register masks (take 2)
      pata_hpt366: fix timing register documentation
      ata: use pci_dev->revision

Shaohua Li (1):
      ahci: disable SNotification capability for ich8

Tejun Heo (2):
      libata-acpi: missing _SDD is not an error
      libata: retry failed FLUSH if device didn't fail it

Thiago Farina (1):
      sata_mv: Clean up hard coded array size calculation.

Vivek Mahajan (1):
      sata_sil24: MSI support, disabled by default

ashish kalra (1):
      sata_fsl: Add asynchronous notification support

 drivers/ata/Kconfig           |   41 +++++++-----
 drivers/ata/Makefile          |    1 
 drivers/ata/ahci.c            |   28 +++++++-
 drivers/ata/ata_generic.c     |    5 +
 drivers/ata/libata-acpi.c     |   15 ++--
 drivers/ata/libata-core.c     |    7 ++
 drivers/ata/libata-eh.c       |   94 ++++++++++++++++++++++++++++
 drivers/ata/libata-scsi.c     |  101 +++++++++++++++++++++++++++++-
 drivers/ata/libata-sff.c      |    2 
 drivers/ata/pata_ali.c        |    4 -
 drivers/ata/pata_cmd64x.c     |  125 +++++++++++++++++++++++++++++++++----
 drivers/ata/pata_cs5536.c     |    2 
 drivers/ata/pata_hpt366.c     |   38 ++++-------
 drivers/ata/pata_hpt37x.c     |  137 +++++++++++++++++++++--------------------
 drivers/ata/pata_hpt3x2n.c    |   37 +++++------
 drivers/ata/pata_it821x.c     |    2 
 drivers/ata/pata_piccolo.c    |  140 ++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/pata_sil680.c     |    6 -
 drivers/ata/pata_sis.c        |   91 ++++++++++++++++++++-------
 drivers/ata/pata_via.c        |   37 +++++++++--
 drivers/ata/sata_fsl.c        |   18 +++--
 drivers/ata/sata_mv.c         |    2 
 drivers/ata/sata_sil24.c      |    9 ++
 drivers/ide/ide-pci-generic.c |    3 
 include/linux/ata.h           |   13 +++
 include/linux/libata.h        |    2 
 include/linux/pci_ids.h       |    7 +-
 27 files changed, 767 insertions(+), 200 deletions(-)
