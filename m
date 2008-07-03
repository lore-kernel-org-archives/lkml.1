Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbYGCRfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbYGCRfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 13:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbYGCRfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 13:35:24 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:17288 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbYGCRfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 13:35:23 -0400
X-BigFish: VPS2(z5edJzzz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K3FY6J-04-36R-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com
Subject: [PATCH 0/6] AMD IOMMU updates
Date: Thu, 3 Jul 2008 19:35:05 +0200
Message-ID: <1215106511-12915-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 03 Jul 2008 17:35:12.0069 (UTC) FILETIME=[2567CF50:01C8DD33]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series of patches contain some updates to the AMD IOMMU code currently in
tip/master. The updates address some objections discussed on the initial
patches and also contain optimization and small code cleanup.
The code with these updates is tested on real hardware under load and showed no
problems.

diffstat:

 arch/x86/Kconfig                  |   10 +++++++++-
 arch/x86/kernel/amd_iommu.c       |   15 ++++++++++-----
 arch/x86/kernel/amd_iommu_init.c  |   16 ++++++----------
 include/asm-x86/amd_iommu_types.h |    2 ++
 4 files changed, 27 insertions(+), 16 deletions(-)



