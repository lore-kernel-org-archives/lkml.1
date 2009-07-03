Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbZGCIbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbZGCIbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbZGCIaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:30:19 -0400
Received: from sg2ehsobe003.messaging.microsoft.com ([207.46.51.77]:29900 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752982AbZGCIaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:30:16 -0400
X-SpamScore: -18
X-BigFish: VPS-18(z21eWz4015Lzz1202hzzz32i61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KM76A4-01-IVX-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [git pull] AMD IOMMU fixes for 2.6.31-rc1
Date: Fri, 3 Jul 2009 10:29:11 +0200
Message-ID: <1246609753-30929-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 03 Jul 2009 08:29:18.0525 (UTC) FILETIME=[5B8C5ED0:01C9FBB8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 7c5371c403abb29f01bc6cff6c5096abdf2dc524:
  Yinghai Lu (1):
        x86: add boundary check for 32bit res before expand e820 resource to alignment

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/fixes

Joerg Roedel (2):
      amd-iommu: handle alias entries correctly in init code
      amd-iommu: set evt_buf_size correctly

 arch/x86/kernel/amd_iommu_init.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

These two patches fix an uncorrect device table initialization issue and a
divide-by-zero error on an event log interrupt. Please pull.

Thanks,

	Joerg


