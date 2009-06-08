Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbZFHOfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbZFHOfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755645AbZFHOe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:34:57 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:49284 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665AbZFHOe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:34:56 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i17ch)
X-FB-SS: 13,
X-WSS-ID: 0KKXCHX-01-S5B-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [git pull][PATCH 0/5] dma-debug minor fixes and cleanups
Date: Mon, 8 Jun 2009 16:34:05 +0200
Message-ID: <1244471650-4632-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
X-OriginalArrivalTime: 08 Jun 2009 14:34:14.0506 (UTC) FILETIME=[323E2CA0:01C9E846]
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

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git dma-debug/fixes

Joerg Roedel (5):
      dma-debug: comment style fixes
      dma-debug: code style fixes
      dma-debug: use pr_* instead of printk(KERN_* ...)
      dma-debug: disable/enable irqs only once in device_dma_allocations
      dma-debug: simplify logic in driver_filter()

 lib/dma-debug.c |  112 +++++++++++++++++++++++++++---------------------------
 1 files changed, 56 insertions(+), 56 deletions(-)

These changes fix various style issues and convert API functions to
newer versions. The last two patches optimize irq enable/disable
frequency and simplify driver filter code to make it more readable.
Please pull.

Thanks,

	Joerg


