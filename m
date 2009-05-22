Return-Path: <linux-kernel-owner+w=401wt.eu-S1758031AbZEVMP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbZEVMP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbZEVMPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:15:50 -0400
Received: from wa4ehsobe002.messaging.microsoft.com ([216.32.181.12]:35851
	"EHLO WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757371AbZEVMPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:15:50 -0400
X-BigFish: VPS-7(z6c9Rzzz1202hzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KK1OQ4-04-9XL-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] suspend/resume support for amd iommu
Date: Fri, 22 May 2009 14:15:31 +0200
Message-ID: <1242994540-28799-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
X-OriginalArrivalTime: 22 May 2009 12:15:42.0095 (UTC) FILETIME=[06A329F0:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements support for suspend/resume in the AMD IOMMU
driver for Linux. Please review.

diffstat:

 arch/x86/include/asm/amd_iommu.h       |    2 +
 arch/x86/include/asm/amd_iommu_types.h |    8 ++
 arch/x86/kernel/amd_iommu.c            |   37 +++++++-
 arch/x86/kernel/amd_iommu_init.c       |  144 ++++++++++++++++----------------
 4 files changed, 114 insertions(+), 77 deletions(-)

shortlog:

Joerg Roedel (9):
      amd-iommu: introduce for_each_iommu* macros
      amd-iommu: consolidate hardware initialization to one function
      amd-iommu: drop pointless iommu-loop in msi setup code
      amd-iommu: remove support for msi-x
      amd-iommu: add function to disable all iommus
      amd-iommu: add function to flush tlb for all domains
      amd-iommu: add function to flush tlb for all devices
      amd_iommu: un __init functions required for suspend/resume
      amd-iommu: implement suspend/resume


