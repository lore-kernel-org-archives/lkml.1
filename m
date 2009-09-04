Return-Path: <linux-kernel-owner+w=401wt.eu-S933487AbZIDKGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487AbZIDKGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 06:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933431AbZIDKGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 06:06:09 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:47220
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933378AbZIDKGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 06:06:08 -0400
X-SpamScore: -12
X-BigFish: VPS-12(z21eWzzz1202hzzz32i6bh203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KPFYPP-03-OJE-01
Date: Fri, 4 Sep 2009 12:05:06 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
CC: osrc-patches@elbe.amd.com
Subject: [git pull] AMD-IOMMU (AMD-Vi) updates for 2.6.32
Message-ID: <20090904100506.GD30765@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
X-OriginalArrivalTime: 04 Sep 2009 10:05:06.0624 (UTC) FILETIME=[2DB4EC00:01CA2D47]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 37d0892c5a94e208cf863e3b7bac014edee4346d:
  Ian Kent (1):
        autofs4 - fix missed case when changing to use struct path

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/2.6.32

Joerg Roedel (37):
      x86/amd-iommu: Dump fault entry on DTE error
      x86/amd-iommu: Dump illegal command on ILLEGAL_COMMAND_ERROR
      x86/amd-iommu: Introduce function for iommu-local domain flush
      x86/amd-iommu: Remove some merge helper code
      x86/amd-iommu: replace "AMD IOMMU" by "AMD-Vi"
      x86/amd-iommu: Remove redundant 'IOMMU' string
      x86/amd-iommu: fix broken check in amd_iommu_flush_all_devices
      x86/amd-iommu: Add function to flush all DTEs on one IOMMU
      x86/amd-iommu: Add reset function for command buffers
      x86/amd-iommu: Reset command buffer on ILLEGAL_COMMAND_ERROR
      x86/amd-iommu: Panic if IOMMU command buffer reset fails
      x86/amd-iommu: Reset command buffer if wait loop fails
      x86/amd-iommu: Make fetch_pte aware of dynamic mapping levels
      x86/amd-iommu: Use fetch_pte in iommu_unmap_page
      x86/amd-iommu: Use fetch_pte in amd_iommu_iova_to_phys
      x86/amd-iommu: Add a gneric version of amd_iommu_flush_all_devices
      x86/amd-iommu: Introduce set_dte_entry function
      x86/amd-iommu: Flush domains if address space size was increased
      x86/amd-iommu: Introduce increase_address_space function
      x86/amd-iommu: Change alloc_pte to support 64 bit address space
      x86/amd-iommu: Remove last usages of IOMMU_PTE_L0_INDEX
      x86/amd-iommu: Remove bus_addr check in iommu_map_page
      x86/amd-iommu: Use 2-level page tables for dma_ops domains
      x86/amd-iommu: Remove old page table handling macros
      x86/amd-iommu: Support higher level PTEs in iommu_page_unmap
      x86/amd-iommu: Change iommu_map_page to support multiple page sizes
      x86/dma: Mark iommu_pass_through as __read_mostly
      x86/amd-iommu: Add core functions for pd allocation/freeing
      x86/amd-iommu: Add passthrough mode initialization functions
      x86/amd-iommu: Fix device table write order
      x86/amd-iommu: Align locking between attach_device and detach_device
      x86/amd-iommu: Make sure a device is assigned in passthrough mode
      x86/amd-iommu: Don't detach device from pt domain on driver unbind
      x86/amd-iommu: Initialize passthrough mode when requested
      Merge branches 'gart/fixes', 'amd-iommu/fixes+cleanups' and 'amd-iommu/fault-handling' into amd-iommu/2.6.32
      Merge branch 'amd-iommu/passthrough' into amd-iommu/2.6.32
      Merge branch 'amd-iommu/pagetable' into amd-iommu/2.6.32

Pavel Vasilyev (1):
      x86/gart: Do not select AGP for GART_IOMMU

 arch/x86/Kconfig                       |    1 -
 arch/x86/include/asm/amd_iommu.h       |    1 +
 arch/x86/include/asm/amd_iommu_types.h |   50 ++--
 arch/x86/kernel/amd_iommu.c            |  489 +++++++++++++++++++++++---------
 arch/x86/kernel/amd_iommu_init.c       |   42 ++-
 arch/x86/kernel/pci-dma.c              |    9 +-
 6 files changed, 429 insertions(+), 163 deletions(-)

These changes include updates and improvements in the page table code,
in fault handling and they implement iommu=pt mode for AMD-Vi too.
Last but not least there are also some minor cleanups and fixes for
AMD-Vi and GART included in this pull-request. All these changes are
compile-, boot- and load-tested.

I had to do three merge commits for this pull request because the
amd-iommu/passthrough and amd-iommu/pagetable branches touch the same
code in some parts and the octopus merge of these branches failed. I had
to merge these two branches seperatly.
Please consider to pull.

Joerg


