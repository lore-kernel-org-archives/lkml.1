Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbZFCI1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbZFCI1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZFCI1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:27:09 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:18176 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbZFCI1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:27:07 -0400
X-SpamScore: -12
X-BigFish: VPS-12(z21eWzzz1202hzzz32i6bh17ch1a3h43j)
X-WSS-ID: 0KKNM4X-03-6C6-01
Date: Wed, 3 Jun 2009 10:26:54 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@elte.hu
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [git pull] dma-debug updates for 2.6.31
Message-ID: <20090603082654.GA22359@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 03 Jun 2009 08:26:54.0960 (UTC) FILETIME=[0D959700:01C9E425]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 83cce2b69eaa4bc7535f98f75b79397baf277470:
  Joerg Roedel (1):
        Merge branches 'amd-iommu/fixes', 'amd-iommu/debug', 'amd-iommu/suspend-resume' and 'amd-iommu/extended-allocator' into amd-iommu/2.6.31

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git dma-debug/2.6.31

FUJITA Tomonori (3):
      dma-debug: use sg_dma_address accessor instead of using dma_address directly
      dma-debug: use sg_dma_len accessor
      dma-debug: fix debug_dma_sync_sg_for_cpu and debug_dma_sync_sg_for_device

Joerg Roedel (6):
      dma-debug: re-add dma memory leak detection
      dma-debug: add variables and checks for driver filter
      dma-debug: add debugfs file for driver filter
      dma-debug: add dma_debug_driver kernel command line
      dma-debug: add documentation for the driver filter
      Merge branches 'dma-debug/fixes' and 'dma-debug/driver-filter' into dma-debug/2.6.31

 Documentation/DMA-API.txt           |   12 ++
 Documentation/kernel-parameters.txt |    7 +
 lib/dma-debug.c                     |  291 ++++++++++++++++++++++++++++++++---
 3 files changed, 288 insertions(+), 22 deletions(-)

The changes include some fixes and a new feature, the driver filter.
With this filter the dma-debug code can be instrumented to only print
error messages originating by a selected driver. The driver to filter
for can be set by a kernel command line or by a new file in debugfs.
Please pull.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

