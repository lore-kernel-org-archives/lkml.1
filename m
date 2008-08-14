Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbYHNR4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbYHNR4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYHNRzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:55:31 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:45487 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbYHNRzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:55:31 -0400
X-BigFish: VPS-13(z21eW5edJzzz10d3izzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K5LR43-03-ZTE-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH 0/4] AMD IOMMU updates for 2.6.27-rc3
Date: Thu, 14 Aug 2008 19:55:14 +0200
Message-ID: <1218736518-25301-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 14 Aug 2008 17:55:18.0551 (UTC) FILETIME=[E9DFDA70:01C8FE36]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

here are 4 update patches for AMD IOMMU which should be merged in 2.6.27. They
fix various issues that came up during tests. They also fix some minor
style issues.

Joerg

git diff --stat tip/master.. :

 arch/x86/kernel/amd_iommu.c       |   19 +++++++++++--------
 arch/x86/kernel/amd_iommu_init.c  |   24 +++++++++++++++++++++---
 include/asm-x86/amd_iommu_types.h |    8 +++++---
 3 files changed, 37 insertions(+), 14 deletions(-)



