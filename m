Return-Path: <linux-kernel-owner+w=401wt.eu-S1751600AbZKCLZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbZKCLZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 06:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbZKCLZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 06:25:30 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:29869
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750879AbZKCLZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 06:25:30 -0500
X-SpamScore: -12
X-BigFish: VPS-12(z21eWzzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KSJ6EA-03-8ZV-02
X-M-MSG: 
Date: Tue, 3 Nov 2009 12:25:21 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] IOMMU updates for 2.6.32-rc5
Message-ID: <20091103112520.GI14009@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 03 Nov 2009 11:25:21.0502 (UTC) FILETIME=[5461FFE0:01CA5C78]
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
      Merge branches 'amd-iommu/fixes' and 'dma-debug/fixes' into iommu/fixes

 arch/x86/include/asm/amd_iommu.h |    1 +
 arch/x86/kernel/amd_iommu.c      |    2 ++
 arch/x86/kernel/amd_iommu_init.c |   24 +++++++++++++++++++++++-
 lib/dma-debug.c                  |    6 ++++--
 4 files changed, 30 insertions(+), 3 deletions(-)

The patches contain two important fixes for the AMD IOMMU driver (one
erratum workaround and a section mismatch that only shows when the
compiler does not inline the iommu_feature_disable function).
Also included in this pull request is da dma-debug fix for a compilation
warning on 32bit with PAE enabled. Please pull.

	Joerg


