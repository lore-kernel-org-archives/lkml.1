Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbZLCPsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbZLCPsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 10:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZLCPsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 10:48:54 -0500
Received: from mail-ew0-f210.google.com ([209.85.219.210]:35781 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbZLCPsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 10:48:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=walicuNqYNcu3vip7eajYuQZNCVCYnc5aikLvuiOE46VcoS+C9R94WVcyjv4H+bCjO
         7kQl+LHudFE85ZU7qGEPdlyPfBmREy2fIOjInAHrWLa9BR/kTTkDGjP1G9I2RzSXDVSi
         3e9MeTJQ/1HoOvCGJwpiMNqVKzHd+qLf3ZwCE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: What's in libata-dev.git?
Date: Thu, 3 Dec 2009 16:47:26 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
References: <20091203075653.GA30612@havoc.gtf.org>
In-Reply-To: <20091203075653.GA30612@havoc.gtf.org>
MIME-Version: 1.0
Message-Id: <200912031647.26342.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 December 2009 08:56:53 am Jeff Garzik wrote:
> 
> This is the contents of the recently-rebased "upstream" branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
> 
> This is what will get sent RSN for 2.6.33.

I re-based my tree on top of Jeff's one.

( Jeff, you probably would want to take ide-pci-generic fix to your tree
  as libata-dev tree currently breaks build for IDE tree. )


The following changes since commit e53bc6adc02e640d9c8c4b14f9dd3a7e6f00179f:
  Mark Nelson (1):
        ahci: let users know that Promise PDC42819 support is limited to SATA devices

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git atang-v1.7

Bartlomiej Zolnierkiewicz (93):
      ide-pci-generic: build fix
      ata_piix: fix MWDMA handling on PIIX3
      ata_piix: unify code for programming PIO and MWDMA timings
      pata_artop: add 32-bit PIO support
      pata_artop: fix chipsets naming
      pata_artop: add Power Management support
      pata_artop: unify ->prereset methods
      pata_artop: remove dead 34MHz PCI clock support
      pata_atiixp: add 32-bit PIO support
      pata_atiixp: no need to program PIO timings for MWDMA
      pata_atiixp: add MWDMA0 support
      pata_atiixp: remove custom BMDMA methods
      pata_atiixp: add proper ->prereset method
      pata_efar: add 32-bit PIO support
      pata_efar: fix wrong PIO timings being programmed
      pata_efar: fix wrong MWDMA timings being programmed
      pata_efar: fix register naming used in efar_set_piomode()
      pata_efar: unify code for programming PIO and MWDMA timings
      pata_efar: MWDMA0 is unsupported
      pata_cmd640: document known issues
      pata_cmd64x: add 32-bit PIO support
      pata_cmd64x: add enablebits checking
      pata_cmd64x: add cmd64x_fixup()
      pata_cs5520: add 32-bit PIO support
      pata_cs5520: remove dead VDMA support
      pata_cs5530: add 32-bit PIO support
      pata_cs5535: add 32-bit PIO support
      pata_cs5535: no need to program PIO0 timings during device init
      pata_cypress: add 32-bit PIO support
      pata_cypress: document known issues
      pata_hpt366: add 32-bit PIO support
      pata_hpt366: add enablebits checking
      pata_hpt366: add hpt36x_find_mode() helper
      pata_hpt37x: add 32-bit PIO support
      pata_hpt3x2n: add 32-bit PIO support
      pata_hpt3x2n: add enablebits checking
      pata_hpt3x2n: fix overclocked MWDMA0 timing
      pata_hpt3x3: Power Management fix
      pata_it8213: add 32-bit PIO support
      pata_it8213: fix UDMA handling
      pata_it8213: add UDMA100 and UDMA133 support
      pata_it8213: fix wrong PIO timings being programmed
      pata_it8213: fix PIO2 underclocking
      pata_it8213: fix wrong MWDMA timings being programmed
      pata_it8213: fix register naming used in it8213_set_piomode()
      pata_it8213: unify code for programming PIO and MWDMA timings
      pata_it8213: fix it8213_pre_reset() documentation
      pata_it8213: MWDMA0 is unsupported
      pata_it821x: add 32-bit PIO support
      pata_jmicron: add 32-bit PIO support
      pata_legacy: do not probe extra ports automatically if PCI is not present
      pata_legacy: fix QDI6580DP support
      pata_legacy: fix access to control register for QDI6580
      pata_legacy: add pointers to QDI65x0 documentation
      pata_legacy: unify QDI ->set_piomode methods
      pata_legacy: use PIO mask defines
      libata: remove no longer needed pata_qdi driver
      libata: remove no longer needed pata_winbond driver
      pata_marvell: fix marvell_pre_reset() documentation
      pata_ns87415: add 32-bit PIO support
      pata_ns87415: Power Management fix
      pata_oldpiix: unify code for programming PIO and MWDMA timings
      pata_oldpiix: MWDMA0 is unsupported
      pata_opti: add 32-bit PIO support
      pata_pdc2027x: add 32-bit PIO support
      pata_pdc2027x: add Power Management support
      pata_pdc202xx_old: add 32-bit PIO support
      pata_pdc202xx_old: Power Management fix
      pata_pdc202xx_old: document known issues
      pata_radisys: fix UDMA handling
      pata_radisys: unify code for programming PIO and MWDMA timings
      pata_rdc: unify code for programming PIO and MWDMA timings
      pata_rdc: MWDMA0 is unsupported
      pata_rz1000: add 32-bit PIO support
      pata_rz1000: Power Management fix
      pata_sc1200: add 32-bit PIO support
      pata_scc: add proper cable detection method
      pata_sch: add 32-bit PIO support
      pata_serverworks: use standard cable detection methods
      pata_serverworks: add serverworks_fixup()
      pata_serverworks: add 32-bit PIO support
      pata_sl82c105: add 32-bit PIO support
      pata_sl82c105: add Power Management support
      pata_sis: add 32-bit PIO support
      pata_sis: Power Management fix
      pata_triflex: add 32-bit PIO support
      pata_via: add 32-bit PIO support
      libata: make ata_sff_data_xfer_noirq() work with 32-bit PIO
      pata_via: clear UDMA transfer mode bit for PIO and MWDMA
      pata_via: add via_fixup()
      libata: add ata_mwdma_to_pio() inline helper
      libata: add ->init_host method
      libata: add private driver field to struct ata_device

 drivers/ata/Kconfig             |   16 ++-
 drivers/ata/Makefile            |    2 -
 drivers/ata/ata_piix.c          |  113 ++++---------
 drivers/ata/libata-core.c       |   14 ++-
 drivers/ata/libata-sff.c        |   12 +-
 drivers/ata/pata_ali.c          |   29 +--
 drivers/ata/pata_amd.c          |   45 ++---
 drivers/ata/pata_artop.c        |  224 ++++++++++++-------------
 drivers/ata/pata_atiixp.c       |  112 ++++---------
 drivers/ata/pata_cmd640.c       |   27 +--
 drivers/ata/pata_cmd64x.c       |   98 +++++++----
 drivers/ata/pata_cs5520.c       |   41 +----
 drivers/ata/pata_cs5530.c       |   33 +---
 drivers/ata/pata_cs5535.c       |   14 +--
 drivers/ata/pata_cypress.c      |    2 +-
 drivers/ata/pata_efar.c         |  121 +++++---------
 drivers/ata/pata_hpt366.c       |   99 +++++++----
 drivers/ata/pata_hpt37x.c       |    4 +-
 drivers/ata/pata_hpt3x2n.c      |   14 ++-
 drivers/ata/pata_hpt3x3.c       |   23 ++--
 drivers/ata/pata_it8213.c       |  138 ++++++---------
 drivers/ata/pata_it821x.c       |   39 ++---
 drivers/ata/pata_jmicron.c      |    2 +-
 drivers/ata/pata_legacy.c       |  156 +++++++----------
 drivers/ata/pata_marvell.c      |    2 +-
 drivers/ata/pata_ninja32.c      |   30 ++--
 drivers/ata/pata_ns87415.c      |   22 ++-
 drivers/ata/pata_oldpiix.c      |   97 +++--------
 drivers/ata/pata_opti.c         |    2 +
 drivers/ata/pata_pdc2027x.c     |   24 ++-
 drivers/ata/pata_pdc202xx_old.c |   37 ++++-
 drivers/ata/pata_qdi.c          |  366 ---------------------------------------
 drivers/ata/pata_radisys.c      |   78 +++------
 drivers/ata/pata_rdc.c          |  108 ++++--------
 drivers/ata/pata_rz1000.c       |   13 ++-
 drivers/ata/pata_sc1200.c       |    2 +-
 drivers/ata/pata_scc.c          |   14 +--
 drivers/ata/pata_sch.c          |    2 +-
 drivers/ata/pata_serverworks.c  |  104 +++++-------
 drivers/ata/pata_sis.c          |   25 +++-
 drivers/ata/pata_sl82c105.c     |   28 +++-
 drivers/ata/pata_triflex.c      |    2 +-
 drivers/ata/pata_via.c          |   74 ++++----
 drivers/ata/pata_winbond.c      |  282 ------------------------------
 drivers/ata/sata_sil.c          |   33 +---
 drivers/ide/ide-pci-generic.c   |    2 +-
 include/linux/ata.h             |   11 ++
 include/linux/libata.h          |   15 ++-
 48 files changed, 925 insertions(+), 1826 deletions(-)
 delete mode 100644 drivers/ata/pata_qdi.c
 delete mode 100644 drivers/ata/pata_winbond.c

