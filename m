Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbZCJFLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbZCJFLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbZCJFLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:11:25 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:28373 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbZCJFLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:11:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VzKhMAXiBGU3IJGQIb7vgC4yuOQhpwuDuIJMgaD60gqJJnU5D6zeOgH7hgPHa0BtLH
         avSp6j2qJZcZi0LxMVVNG4xLjdqZJTE4ZlkeGHWbGcpppUGcZ0XkyhPrKZygjET5a0vX
         01fcHEKPkvw06tf1KLKPMk3/7TAz+QVt+MFmk=
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>
Subject: [PATCH 00/25] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 00:10:25 -0500
Message-Id: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set changes the majority of BUG usage inside ifs to BUG_ON

Stoyan Gaydarov (25):
  [btrfs] BUG to BUG_ON changes
  [staging] BUG to BUG_ON changes
  [net] BUG to BUG_ON changes
  [arm] BUG to BUG_ON changes
  [ia64] BUG to BUG_ON changes
  [mips] BUG to BUG_ON changes
  [x86] BUG to BUG_ON changes
  [sparc] BUG to BUG_ON changes
  [s390] BUG to BUG_ON changes
  [mn10300] BUG to BUG_ON changes
  [alpha] BUG to BUG_ON changes
  [frv] BUG to BUG_ON changes
  [blackfin] BUG to BUG_ON changes
  [mm] BUG to BUG_ON changes
  [cris] BUG to BUG_ON changes
  [m32r] BUG to BUG_ON changes
  [parisc] BUG to BUG_ON changes
  [xtensa] BUG to BUG_ON changes
  [sysctl.c] BUG to BUG_ON changes
  [scsi] BUG to BUG_ON changes
  [afs] BUG to BUG_ON changes
  [reiserfs] BUG to BUG_ON changes
  [drivers/misc] BUG to BUG_ON changes
  [crypto] BUG to BUG_ON changes
  [drivers] BUG to BUG_ON changes

 arch/alpha/kernel/pci_iommu.c            |   15 +++++----------
 arch/arm/common/gic.c                    |    9 +++------
 arch/arm/mach-ebsa110/io.c               |   24 ++++++++----------------
 arch/arm/mach-integrator/pci_v3.c        |    9 +++------
 arch/arm/mach-rpc/dma.c                  |    3 +--
 arch/arm/mach-versatile/pci.c            |    9 +++------
 arch/arm/mm/init.c                       |    3 +--
 arch/blackfin/include/asm/pci.h          |   22 ++++++----------------
 arch/cris/mm/init.c                      |    3 +--
 arch/frv/kernel/uaccess.c                |    6 ++----
 arch/frv/mb93090-mb00/pci-dma-nommu.c    |    6 ++----
 arch/frv/mb93090-mb00/pci-dma.c          |    6 ++----
 arch/ia64/kernel/module.c                |    3 +--
 arch/ia64/kernel/setup.c                 |    3 +--
 arch/ia64/mm/init.c                      |    3 +--
 arch/ia64/sn/kernel/io_common.c          |   15 +++++----------
 arch/ia64/sn/kernel/io_init.c            |   12 ++++--------
 arch/ia64/sn/kernel/setup.c              |    3 +--
 arch/ia64/sn/kernel/sn2/sn_hwperf.c      |    6 ++----
 arch/ia64/sn/pci/pcibr/pcibr_dma.c       |    4 +---
 arch/m32r/kernel/setup.c                 |    3 +--
 arch/m32r/kernel/smp.c                   |    9 +++------
 arch/mips/jazz/jazzdma.c                 |    3 +--
 arch/mips/kernel/traps.c                 |    3 +--
 arch/mips/mm/ioremap.c                   |    9 +++------
 arch/mn10300/kernel/irq.c                |    3 +--
 arch/mn10300/mm/init.c                   |    3 +--
 arch/mn10300/mm/misalignment.c           |    3 +--
 arch/parisc/kernel/pci-dma.c             |   12 ++++--------
 arch/s390/kernel/debug.c                 |    3 +--
 arch/s390/kernel/setup.c                 |    3 +--
 arch/sparc/kernel/traps_64.c             |    3 +--
 arch/sparc/lib/bitext.c                  |   17 +++++++----------
 arch/sparc/mm/srmmu.c                    |    3 +--
 arch/x86/kernel/cpu/common.c             |    6 ++----
 arch/x86/kernel/quirks.c                 |    3 +--
 arch/x86/mach-voyager/voyager_smp.c      |    6 ++----
 arch/xtensa/kernel/pci-dma.c             |    9 +++------
 drivers/ata/pata_hpt366.c                |    3 +--
 drivers/base/iommu.c                     |    4 +---
 drivers/crypto/ixp4xx_crypto.c           |    4 +---
 drivers/gpu/drm/i915/intel_fb.c          |    6 ++----
 drivers/misc/sgi-gru/grukservices.c      |    3 +--
 drivers/misc/sgi-gru/grumain.c           |    3 +--
 drivers/mtd/ssfdc.c                      |    3 +--
 drivers/net/atl1e/atl1e_main.c           |    3 +--
 drivers/net/chelsio/sge.c                |    3 +--
 drivers/net/ixgb/ixgb_osdep.h            |    2 +-
 drivers/net/pppol2tp.c                   |    3 +--
 drivers/net/wireless/ath9k/core.h        |    6 +-----
 drivers/s390/char/tape_3590.c            |    3 +--
 drivers/s390/char/tape_core.c            |    6 ++----
 drivers/s390/char/tape_std.c             |    4 ++--
 drivers/scsi/lpfc/lpfc_els.c             |    3 +--
 drivers/sh/intc.c                        |    3 +--
 drivers/staging/comedi/drivers.c         |    6 ++----
 drivers/staging/otus/wwrap.c             |    3 +--
 drivers/staging/usbip/vhci_sysfs.c       |    3 +--
 drivers/staging/wlan-ng/hfa384x_usb.c    |    4 +---
 fs/afs/netdevices.c                      |    3 +--
 fs/btrfs/ctree.c                         |    3 +--
 fs/btrfs/extent-tree.c                   |    3 +--
 fs/btrfs/free-space-cache.c              |    3 +--
 fs/btrfs/tree-log.c                      |    3 +--
 include/asm-frv/pci.h                    |    7 ++-----
 include/asm-mn10300/unit-asb2303/timex.h |    3 +--
 include/asm-mn10300/unit-asb2305/timex.h |    3 +--
 include/linux/reiserfs_fs.h              |    3 +--
 kernel/sysctl.c                          |    3 +--
 mm/nommu.c                               |   15 +++++----------
 70 files changed, 129 insertions(+), 263 deletions(-)

