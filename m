Return-Path: <linux-kernel-owner+w=401wt.eu-S933585AbZIDJtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585AbZIDJtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933565AbZIDJtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:49:10 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:56741 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933431AbZIDJtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:49:08 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i203h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KPFXXO-02-2HH-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Fixes and Cleanups (AMD-Vi)
Date: Fri, 4 Sep 2009 11:47:23 +0200
Message-ID: <1252057647-32322-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 04 Sep 2009 09:47:29.0375 (UTC) FILETIME=[B78986F0:01CA2D44]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series contains various fixes and cleanups for the AMD-IOMMU
(AMD-Vi) driver which queued up since the last merge window.

Joerg

Diffstat:

 arch/x86/include/asm/amd_iommu_types.h |    2 +-
 arch/x86/kernel/amd_iommu.c            |   10 +---------
 arch/x86/kernel/amd_iommu_init.c       |   14 +++++++-------
 3 files changed, 9 insertions(+), 17 deletions(-)

Shortlog:

Joerg Roedel (4):
      x86/amd-iommu: Remove some merge helper code
      x86/amd-iommu: replace "AMD IOMMU" by "AMD-Vi"
      x86/amd-iommu: Remove redundant 'IOMMU' string
      x86/amd-iommu: fix broken check in amd_iommu_flush_all_devices


