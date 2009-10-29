Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbZJ2Quh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbZJ2Quh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755812AbZJ2Quf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:50:35 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:41438
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755804AbZJ2Qud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:50:33 -0400
X-SpamScore: -12
X-BigFish: VPS-12(z21eWzzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KSAC42-03-DYH-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [GIT PULL] IOMMU updates for 2.6.32-rc5
Date: Thu, 29 Oct 2009 17:50:08 +0100
Message-ID: <1256835012-31410-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5
X-OriginalArrivalTime: 29 Oct 2009 16:50:17.0652 (UTC) FILETIME=[E4EDA740:01CA58B7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 012abeea669ea49636cf952d13298bb68654146a:
  Linus Torvalds (1):
        Linux 2.6.32-rc5

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu/fixes

Joerg Roedel (4):
      x86/amd-iommu: Workaround for erratum 63
      x86/amd-iommu: Un__init function required on shutdown
      dma-debug: Fix compile warning with PAE enabled
      Merge branches 'amd-iommu/fixes', 'dma-debug/fixes' and 'gart/fixes' into iommu/fixes

Pavel Vasilyev (1):
      agp/amd64: Remove GART dependency on AGP_AMD64

 arch/x86/include/asm/amd_iommu.h |    1 +
 arch/x86/kernel/amd_iommu.c      |    2 ++
 arch/x86/kernel/amd_iommu_init.c |   24 +++++++++++++++++++++++-
 drivers/char/agp/Kconfig         |    3 +--
 lib/dma-debug.c                  |    6 ++++--
 5 files changed, 31 insertions(+), 5 deletions(-)

The patches contain two important fixes for the AMD IOMMU driver (one
erratum workaround and a section mismatch that only shows when the
compiler does not inline the iommu_feature_disable function).
Also included in this pull request is da dma-debug fix for a compilation
warning on 32bit with PAE enabled and a previously missed patch which
removes the build dependency between GART and AGP_AMD64 code.
Please pull.

	Joerg


