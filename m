Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbYGYM7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbYGYM7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 08:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYGYM6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 08:58:45 -0400
Received: from mail-va3.bigfish.com ([216.32.180.115]:1436 "EHLO
	mail209-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756117AbYGYM6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 08:58:44 -0400
X-BigFish: VPS11(z1039ozzz10d3izzz32i43j)
X-FB-SS: 13,
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0K4KC18-04-X3D-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com
Subject: [PATCH 0/3] IOMMU: move page number calculation to generic code
Date: Fri, 25 Jul 2008 14:57:57 +0200
Message-Id: <1216990680-1227-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 25 Jul 2008 12:58:00.0294 (UTC) FILETIME=[112ED860:01C8EE56]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patch series introduces a generic iommu_num_pages function into the
IOMMU helper code. This function can be used to calculate the number of pages
an IOMMU has to map for a specific mapping request.

The patchset converts the x86 IOMMU implementations for AMD IOMMU and the GART
to use this function.

Other IOMMU implementations are not changed because I can't test them.

diffstat:

 arch/x86/kernel/amd_iommu.c   |   13 +++++--------
 arch/x86/kernel/pci-gart_64.c |   11 ++++-------
 include/linux/iommu-helper.h  |    1 +
 lib/iommu-helper.c            |    8 ++++++++
 4 files changed, 18 insertions(+), 15 deletions(-)



