Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbZLUPXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbZLUPXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 10:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbZLUPXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 10:23:12 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:13139
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752808AbZLUPXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 10:23:10 -0500
X-SpamScore: -12
X-BigFish: VPS-12(z21eWzzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KV0DCZ-02-36E-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [git pull] IOMMU updates for 2.6.33-rc1
Date: Mon, 21 Dec 2009 16:22:07 +0100
Message-ID: <1261408929-6261-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.4
X-OriginalArrivalTime: 21 Dec 2009 15:22:13.0382 (UTC) FILETIME=[5F26CA60:01CA8251]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,


The following changes since commit 55639353a0035052d9ea6cfe4dde0ac7fcbb2c9f:
  Linus Torvalds (1):
        Linux 2.6.33-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu/fixes

Joerg Roedel (2):
      x86/amd-iommu: Fix initialization failure panic
      Merge branches 'dma-debug/fixes' and 'amd-iommu/fixes' into iommu/fixes

Shaun Ruffell (1):
      dma-debug: Do not add notifier when dma debugging is disabled.

 arch/x86/kernel/amd_iommu_init.c |   10 ++++++++++
 lib/dma-debug.c                  |    5 +++++

These two patches fix possible kernel null-pointer dereferences in the
initialization path of AMD IOMMU and the device notifier path of
dma-debug. Please pull.

	Joerg

 2 files changed, 15 insertions(+), 0 deletions(-)

