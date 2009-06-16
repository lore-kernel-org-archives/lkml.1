Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbZFPI4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbZFPI4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbZFPI4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:56:24 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:53616 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbZFPI4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:56:23 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KLBQ5T-02-3JY-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>
Subject: [git pull][PATCH 0/6] amd-iommu fixes
Date: Tue, 16 Jun 2009 10:56:09 +0200
Message-ID: <1245142575-7166-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
X-OriginalArrivalTime: 16 Jun 2009 08:56:17.0553 (UTC) FILETIME=[4F8AB010:01C9EE60]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 92db1e6af747faa129e236d68386af26a0efc12b:
  Ingo Molnar (1):
        Merge branch 'amd-iommu/fixes' of git://git.kernel.org/.../joro/linux-2.6-iommu into core/iommu

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/fixes

Chris Wright (3):
      amd-iommu: flush domain tlb when attaching a new device
      amd-iommu: disable cmd buffer and evt logging before reprogramming iommu
      amd-iommu: resume cleanup

Joerg Roedel (3):
      amd-iommu: disable IOMMU hardware on shutdown
      x86: disable IOMMUs on kernel crash
      amd-iommu: set event buffer head and tail to 0 manually

 arch/x86/include/asm/amd_iommu.h |    2 ++
 arch/x86/kernel/amd_iommu.c      |   16 ++++++++++++++++
 arch/x86/kernel/amd_iommu_init.c |   26 +++++++++++++++++++-------
 arch/x86/kernel/crash.c          |    6 ++++++
 arch/x86/kernel/pci-dma.c        |    2 ++
 5 files changed, 45 insertions(+), 7 deletions(-)

These patches mostly fixes issues in the AMD IOMMU driver with kexec and
kdump. Another fix is to disable the IOMMU hardware on shutdown and
crash to get out of the way for the BIOS. This fixed power-off on my
test machine. Please pull.

	Joerg


