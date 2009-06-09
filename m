Return-Path: <linux-kernel-owner+w=401wt.eu-S1761198AbZFIN60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761198AbZFIN60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbZFIN5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:57:46 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:29315
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755766AbZFIN5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:57:45 -0400
X-SpamScore: -1
X-BigFish: VPS-1(zz4015Lzz1202hzzz32i17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KKZ5FZ-04-0AI-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [git pull][PATCH 0/4] amd-iommu fixes for tip/core/iommu
Date: Tue, 9 Jun 2009 15:57:16 +0200
Message-ID: <1244555840-3855-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
X-OriginalArrivalTime: 09 Jun 2009 13:57:30.0908 (UTC) FILETIME=[3B358DC0:01C9E90A]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 62a6f465f6572e1f28765c583c12753bb3e23715:
  Ingo Molnar (1):
        Merge branch 'dma-debug/2.6.31' of git://git.kernel.org/.../joro/linux-2.6-iommu into core/iommu

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/fixes

Jiri Slaby (1):
      amd_iommu: fix lock imbalance

Joerg Roedel (4):
      Merge commit 'tip/core/iommu' into amd-iommu/fixes
      amd-iommu: remove BUS_NOTIFY_BOUND_DRIVER handling
      amd-iommu: detach device explicitly before attaching it to a new domain
      amd-iommu: remove unnecessary "AMD IOMMU: " prefix

 arch/x86/kernel/amd_iommu.c |   22 ++++++----------------
 1 files changed, 6 insertions(+), 16 deletions(-)

These patches fix issues with device assignment to KVM, a possible
deadlock due to an unreleased lock and a minor printk style issue.
Please pull.

Thanks,

	Joerg


