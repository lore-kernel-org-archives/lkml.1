Return-Path: <linux-kernel-owner+w=401wt.eu-S932159Ab0AVRSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab0AVRSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948Ab0AVRSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:18:42 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:39068 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962Ab0AVRSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:18:39 -0500
X-SpamScore: -18
X-BigFish: VPS-18(z21eWz4015Lzz1202hzzz32i6bh63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KWNS2C-02-7F6-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU fixes for 2.6.33-rc5
Date: Fri, 22 Jan 2010 18:18:08 +0100
Message-ID: <1264180693-27197-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
X-OriginalArrivalTime: 22 Jan 2010 17:18:15.0626 (UTC) FILETIME=[E230EAA0:01CA9B86]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 92dcffb916d309aa01778bf8963a6932e4014d07:
  Linus Torvalds (1):
        Linux 2.6.33-rc5

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu/fixes

Joerg Roedel (5):
      x86/amd-iommu: Fix possible integer overflow
      x86/amd-iommu: Fix NULL pointer dereference in __detach_device()
      x86/amd-iommu: Fix IOMMU-API initialization for iommu=pt
      x86/amd-iommu: Fix deassignment of a device from the pt_domain
      Merge branches 'amd-iommu/fixes' and 'dma-debug/fixes' into iommu/fixes

Thiago Farina (1):
      lib/dma-debug.c: mark file-local struct symbol static.

 arch/x86/include/asm/amd_iommu_proto.h |    1 +
 arch/x86/kernel/amd_iommu.c            |   23 ++++++++++++++++-------
 arch/x86/kernel/amd_iommu_init.c       |    3 +++
 lib/dma-debug.c                        |    2 +-
 4 files changed, 21 insertions(+), 8 deletions(-)

The patches fix several issues with device kvm device assignement when the amd
iommu driver is configured to run in passthrough mode. One patch fixes a
possible integer overflow in the driver as well. The last patch in the series
fixes a build warning in the dma-api debug code. Please pull.

Thanks,

	Joerg


