Return-Path: <linux-kernel-owner+w=401wt.eu-S934505AbXGTApc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934505AbXGTApc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 20:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759848AbXGTApW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 20:45:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:17502 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759364AbXGTApV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 20:45:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,559,1175497200"; 
   d="scan'208";a="252605866"
From: Shannon Nelson <shannon.nelson@intel.com>
Subject: [PATCH 0/7] I/OAT: Add support for DCA - Direct Cache Access
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, jeff@garzik.org, dan.j.williams@intel.com,
       christopher.leech@intel.com, peter.p.waskiewicz.jr@intel.com
Date: Thu, 19 Jul 2007 17:44:34 -0700
Message-ID: <20070720004403.13564.14294.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements support for providers and clients of
Direct Cache Access (DCA), a method for warming the cache in the correct
CPU before needing data.

This series applies on GIT commit 5bae7ac9feba925fd0099057f6b23d7be80b7b41

ioat-new-device-ids.patch
	- add devices id's for newer Intel chipsets which support DMA and DCA
ioat-rename-source-file.patch
	- prepare for adding new functionality
ioat-dma-cleanups.patch
	- cleanup some code ugliness
ioat-split-startup-code.patch
	- split the DMA support code from the PCI startup
ioat-add-msi-msix-support.patch
	- add support for various interrupt handling schemes
ioat-add-dca-support.patch
	- add the dca driver
ioat-add-ioat-dca.patch
	- add DCA services to the ioatdma driver

Please pull from my git tree at
	git://lost.foo-projects.org/~sln/linux-2.6 dca-upstream

Thanks to Dan Williams, Auke Kok, PJ Waskiewicz, and Chris Leech for their
help.

sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish. 
