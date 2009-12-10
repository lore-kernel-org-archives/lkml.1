Return-Path: <linux-kernel-owner+w=401wt.eu-S934322AbZLJL4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934322AbZLJL4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 06:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934216AbZLJLz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 06:55:57 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:52508
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934206AbZLJLzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 06:55:54 -0500
X-SpamScore: -14
X-BigFish: VPS-14(z21eWzzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KUFQGZ-02-41N-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [git pull] AMD IOMMU fixes for 2.6.33
Date: Thu, 10 Dec 2009 12:55:33 +0100
Message-ID: <1260446135-16460-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.4
X-OriginalArrivalTime: 10 Dec 2009 11:55:46.0951 (UTC) FILETIME=[B5B82970:01CA798F]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 4528752f49c1f4025473d12bc5fa9181085c3f22:
  Darrick J. Wong (1):
        x86, Calgary IOMMU quirk: Find nearest matching Calgary while walking up the PCI tree

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/fixes

Joerg Roedel (2):
      x86/amd-iommu: Fix passthrough mode
      x86/amd-iommu: Fix PCI hotplug with passthrough mode

 arch/x86/include/asm/amd_iommu_proto.h |    4 ++-
 arch/x86/kernel/amd_iommu.c            |   46 +++++++++++++++++++++++++++++---
 arch/x86/kernel/amd_iommu_init.c       |    9 ++++++
 3 files changed, 54 insertions(+), 5 deletions(-)

The data structure changes introduced a regression when the IOMMU runs in
passthrough mode. These updates fix these regressions. Please pull.

	Joerg


