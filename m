Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbZIKGmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbZIKGmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 02:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZIKGmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 02:42:44 -0400
Received: from havoc.gtf.org ([69.61.125.42]:57553 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbZIKGmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 02:42:43 -0400
Date: Fri, 11 Sep 2009 02:42:46 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: What's in libata-dev.git?
Message-ID: <20090911064246.GA8422@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a summary of the changes current queued on the #upstream branch
of git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

These will be pushed to Linus in the next day or so, when merges start
flowing.

linux-ide hackers, speak up is something is obviously wrong or missing.

The only outstanding patch is Robert Hancock's enhance-command-parsing
patch:  I'm still on the fence about leaving the huge switch table, or
choosing a better data structure.


Alan Cox (1):
      [libata] Add pata_rdc driver for RDC ATA devices

Ashish Kalra (1):
      sata_fsl: Defer non-ncq commands when ncq commands active

Jeff Garzik (2):
      [libata] EH: freeze port before aborting commands
      [libata] sata_sil: disable DMA engine in sil_freeze()

Joe Perches (1):
      drivers/ata: Remove unnecessary semicolons

Julia Lawall (1):
      drivers/ata: use resource_size

Marcin Slusarz (1):
      pata_rz1000: use printk_once

Martin K. Petersen (1):
      libata: Delegate nonrot flag setting to SCSI

Matthew Garrett (1):
      libata: Export AHCI capabilities

Otavio Salvador (1):
      pata_cs5535: add pci id for AMD based CS5535 controllers

Robert Hancock (2):
      libata: add command name parsing for error output
      sata_sil24: always set protocol override for non-ATAPI data commands

Shane Huang (3):
      libata: add SATA PMP revision information for spec 1.2
      ahci: Add AMD SB900 SATA/IDE controller device IDs
      ahci: kill @force_restart and refine CLO for ahci_kick_engine()

Shaohua Li (1):
      [libata] add DMA setup FIS auto-activate feature

Tejun Heo (9):
      libata: clear eh_info on reset completion
      libata: remove spindown skipping and warning
      sata_sis: convert to slave_link
      libata: unbreak TPM filtering by reorganizing ata_scsi_pass_thru()
      dmi: fix date handling in dmi_get_year()
      dmi: extend dmi_get_year() to dmi_get_date()
      ahci: make ahci_asus_m2a_vm_32bit_only() quirk more generic
      ahci: Gigabyte GA-MA69VM-S2 can't do 64bit DMA
      libata: fix off-by-one error in ata_tf_read_block()


 Documentation/feature-removal-schedule.txt |   18 -
 arch/x86/pci/direct.c                      |    5 
 drivers/acpi/blacklist.c                   |    5 
 drivers/ata/Kconfig                        |   21 +
 drivers/ata/Makefile                       |    1 
 drivers/ata/ahci.c                         |  143 +++++++---
 drivers/ata/libata-acpi.c                  |    7 
 drivers/ata/libata-core.c                  |   44 ++-
 drivers/ata/libata-eh.c                    |  146 ++++++++++
 drivers/ata/libata-pmp.c                   |    2 
 drivers/ata/libata-scsi.c                  |  159 +++--------
 drivers/ata/libata.h                       |    1 
 drivers/ata/pata_atiixp.c                  |    1 
 drivers/ata/pata_cs5535.c                  |    3 
 drivers/ata/pata_octeon_cf.c               |    4 
 drivers/ata/pata_platform.c                |    8 
 drivers/ata/pata_rb532_cf.c                |    2 
 drivers/ata/pata_rdc.c                     |  400 +++++++++++++++++++++++++++++
 drivers/ata/pata_rz1000.c                  |    4 
 drivers/ata/sata_fsl.c                     |    1 
 drivers/ata/sata_inic162x.c                |    2 
 drivers/ata/sata_mv.c                      |    2 
 drivers/ata/sata_sil.c                     |   13 
 drivers/ata/sata_sil24.c                   |   11 
 drivers/ata/sata_sis.c                     |   75 +----
 drivers/firmware/dmi_scan.c                |   77 ++++-
 drivers/ide/atiixp.c                       |    1 
 drivers/pci/quirks.c                       |    4 
 include/linux/ata.h                        |   36 ++
 include/linux/dmi.h                        |   13 
 include/linux/libata.h                     |    3 
 include/linux/pci_ids.h                    |    4 
 32 files changed, 946 insertions(+), 270 deletions(-)

