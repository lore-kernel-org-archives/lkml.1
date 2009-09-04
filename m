Return-Path: <linux-kernel-owner+w=401wt.eu-S933576AbZIDJpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576AbZIDJpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933570AbZIDJpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:45:44 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:4914 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933476AbZIDJpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:45:40 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KPFXRW-02-2ER-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] Improved fault handling for AMD-IOMMU (AMD-Vi)
Date: Fri, 4 Sep 2009 11:44:34 +0200
Message-ID: <1252057482-32207-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 04 Sep 2009 09:44:45.0132 (UTC) FILETIME=[55A408C0:01CA2D44]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series of patches implements improved fault handling in the AMD-IOMMU
(AMD-Vi) driver. The debug output is more verbose for some errors. With these
patches the driver also tries to recover from IOMMU command handling errors
instead of just do a panic.

Joerg

Diffstat:

 arch/x86/include/asm/amd_iommu_types.h |    6 ++
 arch/x86/kernel/amd_iommu.c            |  109 ++++++++++++++++++++++++++------
 arch/x86/kernel/amd_iommu_init.c       |   20 +++++--
 3 files changed, 111 insertions(+), 24 deletions(-)

Shortlog:

Joerg Roedel (8):
      x86/amd-iommu: Dump fault entry on DTE error
      x86/amd-iommu: Dump illegal command on ILLEGAL_COMMAND_ERROR
      x86/amd-iommu: Introduce function for iommu-local domain flush
      x86/amd-iommu: Add function to flush all DTEs on one IOMMU
      x86/amd-iommu: Add reset function for command buffers
      x86/amd-iommu: Reset command buffer on ILLEGAL_COMMAND_ERROR
      x86/amd-iommu: Panic if IOMMU command buffer reset fails
      x86/amd-iommu: Reset command buffer if wait loop fails


