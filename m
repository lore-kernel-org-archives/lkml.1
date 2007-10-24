Return-Path: <linux-kernel-owner+w=401wt.eu-S1757608AbXJXKwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608AbXJXKwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 06:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757369AbXJXKvC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 06:51:02 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:42570 "EHLO
	outbound3-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757357AbXJXKvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 06:51:00 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>,
       "Muli Ben-Yehuda" <muli@il.ibm.com>
Subject: [PATCH 0/4] x86: some GART cleanups
Date: Wed, 24 Oct 2007 12:49:45 +0200
Message-ID: <11932229902428-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
X-OriginalArrivalTime: 24 Oct 2007 10:49:50.0868 (UTC)
 FILETIME=[9A544D40:01C8162B]
MIME-Version: 1.0
X-WSS-ID: 6B01FCDB2IW68027-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches contains cleanups for the GART IOMMU implementation in
Linux. It mostly renames symbols to make clear that they belong only to the
GART and not to the implementations for other IOMMUs. It also makes some
unnecessary exported functions static in the GART implementation. The patches
apply cleanly to Linus latest git tree. Here is the complete diffstat:

 arch/x86/kernel/Makefile_64      |    2 +-
 arch/x86/kernel/aperture_64.c    |   15 ++++++++-------
 arch/x86/kernel/early-quirks.c   |   10 +++++-----
 arch/x86/kernel/pci-calgary_64.c |    2 +-
 arch/x86/kernel/pci-dma_64.c     |   10 +++++-----
 arch/x86/kernel/pci-gart_64.c    |   19 +++++++++----------
 arch/x86/kernel/pci-nommu_64.c   |    2 +-
 arch/x86/kernel/pci-swiotlb_64.c |    2 +-
 arch/x86/kernel/reboot_64.c      |    2 +-
 arch/x86_64/Kconfig              |    6 +++---
 arch/x86_64/Kconfig.debug        |    2 +-
 arch/x86_64/defconfig            |    2 +-
 drivers/char/agp/Kconfig         |    4 ++--
 drivers/char/agp/amd64-agp.c     |    2 +-
 drivers/pci/intel-iommu.c        |    2 +-
 drivers/usb/core/message.c       |    2 +-
 include/asm-x86/gart.h           |   20 +++++++++-----------
 include/asm-x86/pci_64.h         |    3 +--
 18 files changed, 52 insertions(+), 55 deletions(-)



