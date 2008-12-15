Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbYLOOTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbYLOOTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYLOOS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:18:27 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:23217 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbYLOOS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:18:26 -0500
X-BigFish: VPS-23(z21eW5edJz936eQzzzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KBX923-04-RH5-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/22] more AMD IOMMU updates for 2.6.29
Date: Mon, 15 Dec 2008 15:17:43 +0100
Message-ID: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
X-OriginalArrivalTime: 15 Dec 2008 14:18:05.0819 (UTC) FILETIME=[F29204B0:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the rest of AMD IOMMU updates for the 2.6.29 merge window (the
other part is contained in the KVM device passthrough patchsets posted
before).
These patches include some cleanups and improvements for PCI device
hotplug. The most interesting part is the new stats collection facility.
Once enabled, the user can see various high-level statistics about what
the IOMMU code (mostly limited to DMA-API) is doing in debugfs. This can
be used to optimize this and other code (e.g. pv-dma in KVM) in the
future.

Joerg

diffstat:

 arch/x86/Kconfig                       |   10 +++
 arch/x86/include/asm/amd_iommu_types.h |   46 +++++++++----
 arch/x86/kernel/amd_iommu.c            |  117 ++++++++++++++++++++++++++++++--
 arch/x86/kernel/amd_iommu_init.c       |   15 ++---
 4 files changed, 160 insertions(+), 28 deletions(-)



