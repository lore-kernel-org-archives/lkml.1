Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbXGBPQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbXGBPQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 11:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbXGBPQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 11:16:42 -0400
Received: from havoc.gtf.org ([69.61.125.42]:48973 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbXGBPQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 11:16:41 -0400
Date: Mon, 2 Jul 2007 11:16:39 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [info] What's in libata-dev.git?
Message-ID: <20070702151639.GA10948@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



What follows are the changes contained in libata-dev.git, listed on a
branch-by-branch basis.  The double "====" lines separate each branch's
contents.  Each branch is accompanied by a 'STATUS' line, indicating the
upstream status of each branch.

I have patches from Alan (pata_sis FIFO whack, pata_dma option), Tejun,
Albert and Kristen still to be reviewed.  Will get to those on Friday,
after the July 4th US holiday.

	Jeff




===========================================================================
===========================================================================

The following changes are found in the 'upstream' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
(this is what is queued for 2.6.23 currently)

Alessandro Zummo (1):
      [libata] pata_ixp4xx: convert to new EH

Jeff Garzik (13):
      [libata] pata_atiixp: add SB700 PCI ID
      [libata] sata_sil: register table cleanup
      [libata] PATA drivers: remove ATA_FLAG_SRST
      [libata] drivers: remove 'void __iomem *' casts from pre-iomap days
      [libata] pdc_adma: Reorder initializers with a couple structs
      [libata] sata_sx4: named constant cleanup
      [libata] pata_sil680: minor cleanups from benh
      [libata] ahci: Factor out SATA port init into a separate function
      [libata] ahci: minor internal cleanups
      [libata] sata_sx4, sata_via: minor documentation updates
      [ATA] Add named constant for ATAPI command DEVICE RESET
      [libata] ahci: minor internal cleanups
      [libata] pata_ixp4xx: kill unused var

Jens Axboe (1):
      use_clustering (sht) bit set to 0 in AHCI ?

Tejun Heo (8):
      libata-acpi: implement ata_acpi_associate()
      libata-acpi: clean up ata_acpi_exec_tfs()
      libata-acpi: miscellaneous cleanups
      libata: reimplement ACPI invocation
      libata-acpi: remove redundant checks
      libata-acpi: implement _GTM/_STM support
      libata: replace ap->cbl tests with ATA_FLAG_SATA tests
      ata_piix: fix pio/mwdma programming

 drivers/ata/ahci.c              |  102 ++--
 drivers/ata/ata_generic.c       |    2 
 drivers/ata/ata_piix.c          |   23 -
 drivers/ata/libata-acpi.c       |  914 +++++++++++++++++-----------------------
 drivers/ata/libata-core.c       |   25 -
 drivers/ata/libata-eh.c         |   11 
 drivers/ata/libata.h            |   18 
 drivers/ata/pata_ali.c          |   14 
 drivers/ata/pata_amd.c          |   20 
 drivers/ata/pata_artop.c        |    6 
 drivers/ata/pata_atiixp.c       |    3 
 drivers/ata/pata_cmd640.c       |    2 
 drivers/ata/pata_cmd64x.c       |   12 
 drivers/ata/pata_cs5530.c       |    4 
 drivers/ata/pata_cs5535.c       |    2 
 drivers/ata/pata_cypress.c      |    2 
 drivers/ata/pata_efar.c         |    2 
 drivers/ata/pata_hpt366.c       |    2 
 drivers/ata/pata_hpt37x.c       |   12 
 drivers/ata/pata_hpt3x2n.c      |    2 
 drivers/ata/pata_hpt3x3.c       |    2 
 drivers/ata/pata_icside.c       |    2 
 drivers/ata/pata_it8213.c       |    2 
 drivers/ata/pata_it821x.c       |    4 
 drivers/ata/pata_ixp4xx_cf.c    |   76 +--
 drivers/ata/pata_jmicron.c      |    2 
 drivers/ata/pata_marvell.c      |    4 
 drivers/ata/pata_netcell.c      |    2 
 drivers/ata/pata_ns87410.c      |    2 
 drivers/ata/pata_oldpiix.c      |    2 
 drivers/ata/pata_opti.c         |    2 
 drivers/ata/pata_optidma.c      |    4 
 drivers/ata/pata_pdc202xx_old.c |    6 
 drivers/ata/pata_radisys.c      |    2 
 drivers/ata/pata_rz1000.c       |    2 
 drivers/ata/pata_sc1200.c       |    2 
 drivers/ata/pata_serverworks.c  |    8 
 drivers/ata/pata_sil680.c       |   17 
 drivers/ata/pata_sis.c          |   14 
 drivers/ata/pata_sl82c105.c     |    4 
 drivers/ata/pata_triflex.c      |    2 
 drivers/ata/pdc_adma.c          |   18 
 drivers/ata/sata_inic162x.c     |    4 
 drivers/ata/sata_promise.c      |    8 
 drivers/ata/sata_sil.c          |    5 
 drivers/ata/sata_svw.c          |   11 
 drivers/ata/sata_sx4.c          |  166 ++++---
 drivers/ata/sata_via.c          |    4 
 include/linux/ata.h             |    1 
 include/linux/libata.h          |   28 +
 50 files changed, 791 insertions(+), 793 deletions(-)

===========================================================================
===========================================================================

The following changes are found in the 'mv-ahci' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

Jeff Garzik (2):
      [libata] AHCI: get Marvell SATA going (PATA portion of chip not supported)

 drivers/ata/ahci.c     |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 45 insertions(+), 2 deletions(-)

===========================================================================
===========================================================================

The following changes are found in the 'mv-eh' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

Jeff Garzik (11):
      [libata] sata_mv: first cut at new EH
      [libata] sata_mv: move PCI error handling into separate function
      [libata] sata_mv: handle PCI error properly, within new EH
      [libata] sata_mv: convert IRQ handler over to new EH
      [libata] sata_mv: clean up vestiges of old EH
      [libata] sata_mv EH: 50xx fixes, fold non-EDMA EH into EDMA EH path
      [libata] sata_mv: improve EH handling with additional hooks
      [libata] sata_mv: more EH fixes
      [libata mv-eh] sata_mv: build fix for cable detect
      [libata] sata_mv: update EH code for new deadline-based probe sequencing

 drivers/ata/sata_mv.c  |  468 +++++++++++++++++++++++++++++++++----------------
 2 files changed, 324 insertions(+), 146 deletions(-)

===========================================================================
===========================================================================

The following changes are found in the 'new-eh' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

Jeff Garzik (7):
      [libata] pdc_adma: rough draft conversion to new-EH
      [libata] pdc_adma: no longer any need to set old-EH-related ATA flags
      [libata] sata_qstor: rough draft conversion to new libata EH
      [libata] Remove unused [__]sata_phy_reset()
      [libata] sata_sx4: convert to new EH
      [libata] Remove ata_bus_reset(), which is now dead code

 drivers/ata/libata-core.c |  167 ----------------------------------------------
 drivers/ata/pdc_adma.c    |   82 ++++++++++++++++++----
 drivers/ata/sata_qstor.c  |   65 ++++++++++++-----
 drivers/ata/sata_sx4.c    |   96 ++++++++++++++++----------
 include/linux/libata.h    |    3 
 6 files changed, 175 insertions(+), 240 deletions(-)

===========================================================================
===========================================================================

The following changes are found in the 'sii-lbt' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

Jeff Garzik (3):
      [libata] sata_sil: Turn on Large Block Transfer (LBT) feature
      [libata sii-lbt] sata_sil: remove cast left over from pre-iomap days

 drivers/ata/sata_sil.c |  106 +++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 99 insertions(+), 9 deletions(-)

===========================================================================
===========================================================================

The following changes are found in the 'sil680-mmio' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

Benjamin Herrenschmidt (1):
      [libata] pata_sil680: Add MMIO support

Jeff Garzik (2):
      [libata] pata_sil680: fix mismerge; remove ATA_FLAG_SRST (again)

 drivers/ata/pata_sil680.c |   61 ++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 58 insertions(+), 5 deletions(-)

