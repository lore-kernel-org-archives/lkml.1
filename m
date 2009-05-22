Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbZEVMHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbZEVMHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbZEVMH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:07:27 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:47975 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbZEVMH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:07:26 -0400
X-BigFish: VPS-12(z21eWzzz1202hzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KK1OB7-04-9QN-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] amd-iommu fixes for 2.6.31
Date: Fri, 22 May 2009 14:06:27 +0200
Message-ID: <1242993991-28613-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
X-OriginalArrivalTime: 22 May 2009 12:06:44.0518 (UTC) FILETIME=[C6376C60:01C9DAD5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patchset contain the fixes for the AMD IOMMU driver in the
Linux kernel I have queued up for 2.6.31. Please review.

diffstat:

 arch/x86/kernel/amd_iommu.c      |    6 +++++-
 arch/x86/kernel/amd_iommu_init.c |    6 ++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

shortlog:

Chris Wright (1):
      amd iommu: properly detach from protection domain on ->remove

Joerg Roedel (1):
      amd-iommu: make sure only ivmd entries are parsed

Neil Turton (2):
      amd-iommu: fix an off-by-one error in the AMD IOMMU driver.
      amd-iommu: fix the handling of device aliases in the AMD IOMMU driver.


