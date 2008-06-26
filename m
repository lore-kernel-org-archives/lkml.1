Return-Path: <linux-kernel-owner+w=401wt.eu-S1759782AbYFZTiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759782AbYFZTiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757636AbYFZT3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:29:16 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:27396 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759959AbYFZT3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:29:08 -0400
X-BigFish: VPS-4(zz1be0M3117Kzz10d3izzz32i43j)
X-WSS-ID: 0K334RT-03-2YY-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org
Subject: [PATCH 00/34] AMD IOMMU driver
Date: Thu, 26 Jun 2008 21:27:36 +0200
Message-ID: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 26 Jun 2008 19:28:11.0424 (UTC) FILETIME=[C5530A00:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the first post of the initial driver for AMD IOMMU hardware. The driver
is tested on hardware with various loads (disk and network) and showed no
problems.

It currently supports DMA remapping using the dma_ops API in the x86
architecture code. It also supports isolation of device DMA address spaces as
far as the hardware allows that (means each device can get its own DMA address
space and can't access the DMA memory of other devices).

Please give this code a good review and send me your comments about it so that
I can fix all possible bugs and objections and move this driver forward to
merging quality.

Kind regards,

Joerg Roedel

git diff --stat:

 Documentation/kernel-parameters.txt |   12 +
 MAINTAINERS                         |    6 +
 arch/x86/Kconfig                    |    7 +
 arch/x86/kernel/Makefile            |    1 +
 arch/x86/kernel/amd_iommu.c         |  955 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/amd_iommu_init.c    |  842 ++++++++++++++++++++++++++++++
 arch/x86/kernel/pci-dma.c           |    5 +
 include/asm-x86/amd_iommu.h         |   32 ++
 include/asm-x86/amd_iommu_types.h   |  242 +++++++++
 9 files changed, 2102 insertions(+), 0 deletions(-)



