Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZEVMNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZEVMNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbZEVMNC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:13:02 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:62342 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbZEVMNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:13:00 -0400
X-BigFish: VPS-12(z21eWzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KK1OLD-03-92N-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] amd-iommu debug patches for 2.6.31
Date: Fri, 22 May 2009 14:12:42 +0200
Message-ID: <1242994369-28697-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
X-OriginalArrivalTime: 22 May 2009 12:12:49.0808 (UTC) FILETIME=[9FF24100:01C9DAD6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains updates to the debugging code in the AMD IOMMU
driver for Linux. It introduces two additional features:

  * A new command line parameter to let the driver dump the parsed
    contents of the IVRS ACPI table to dmesg. This is a debug feature to
    make it easier to find the bug for problems reported to me
  * A new Kconfig entry to enable IOMMU stress testing code. I made this
    Kconfig entry generic because other IOMMU implementations may pick
    this up as well.

Please review.

diffstat:

 arch/x86/Kconfig.debug                 |    8 +++
 arch/x86/include/asm/amd_iommu_types.h |    6 ++
 arch/x86/kernel/amd_iommu.c            |   10 ++-
 arch/x86/kernel/amd_iommu_init.c       |  109 ++++++++++++++++++++++++++++++++
 4 files changed, 129 insertions(+), 4 deletions(-)

shortlog:

Joerg Roedel (7):
      amd-iommu: add amd_iommu_dump parameter
      amd-iommu: add dump for iommus described in ivrs table
      amd-iommu: print ivhd information to dmesg when requested
      amd-iommu: print ivmd information to dmesg when requested
      amd-iommu: move protection domain printk to dump code
      x86/iommu: add IOMMU_STRESS Kconfig entry
      amd-iommu: disable device isolation with CONFIG_IOMMU_STRESS


