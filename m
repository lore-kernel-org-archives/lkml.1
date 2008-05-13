Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbYEMRmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbYEMRmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756414AbYEMRmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:42:36 -0400
Received: from outbound-mail-37.bluehost.com ([69.89.20.191]:41455 "HELO
	outbound-mail-37.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755427AbYEMRmf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:42:35 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [git pull] PCI fixes
Date: Tue, 13 May 2008 10:42:32 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805131042.32278.jbarnes@virtuousgeek.org>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the PCI fixes:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

This includes a few important but perhaps slightly more dangerous fixes than
the previous set.  Highlights are:  a fix for the X MTRR mapping
incompatibility bug, a critical fix for ISA DMA, and support for more complex
_OSC topologies.  In order to fixup the changelog, I ended up rebasing this
time, hopefully I got everything right.

Thanks,
Jesse

Björn Krombholz (1):
      PCI: enable nv_msi_ht_cap_quirk for ALi bridges

Kenji Kaneshige (3):
      PCI ACPI: fix uninitialized variable in __pci_osc_support_set
      ACPI/PCI: handle multiple _OSC
      ACPI/PCI: another multiple _OSC memory leak fix

Shaohua Li (1):
      ACPI/PCI: handle multiple _OSC

Takashi Iwai (1):
      x86/PCI: fix broken ISA DMA

Venki Pallipadi (1):
      x86/PCI: X86_PAT & mprotect

mark gross (1):
      PCI: Make the intel-iommu_wait_op macro work when jiffies are not running

 arch/x86/kernel/pci-dma.c |    8 ++-
 arch/x86/pci/i386.c       |    4 -
 drivers/pci/intel-iommu.c |    6 +-
 drivers/pci/pci-acpi.c    |  109 +++++++++++++++++++++++++++++++++-------------
 drivers/pci/quirks.c      |    1 
 5 files changed, 89 insertions(+), 39 deletions(-)
