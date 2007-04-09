Return-Path: <linux-kernel-owner+w=401wt.eu-S965085AbXDIWsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965085AbXDIWsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 18:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbXDIWsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 18:48:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:49150 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589AbXDIWsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 18:48:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,388,1170662400"; 
   d="scan'208"; a="210638793:sNHT23067443"
Message-Id: <20070409215552.221374000@intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 09 Apr 2007 14:55:52 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com
Cc: asit.k.mallick@intel.com, suresh.b.siddha@intel.com
Cc: anil.s.keshavamurthy@intel.com, arjan@linux.intel.com
Cc: ashok.raj@intel.com, shaohua.li@intel.com
Subject: [patch 0/8] [Intel IOMMU] Support for Intel Virtualization Technology for Directed I/O
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Pleased to announce support for Intel(R) Virtualization Technology for 
Directed I/O use as an IOMMU in Linux.

This is a series of patches to support the same. 

A brief description of the patches follows.

1. Support for ACPI framework to parse and work with DMA Remapping Tables.
2. Add support for PCI infrastructure to search parent relationships.
3. Hardware support for providing DMA remapping support for Intel Chipsets.
4. Supporting Zero Length Reads on DMAR's not able to support ZLR.
5. Graphics driver workarounds to provide unity map since they dont use dma api.
6. Updates to Documentation area for startup options and some basics.
7. Workaround to provide unity map for ISA bridge device to enable floppy disk.
8. Ability to preserve some mappings for devices not able to address entire 
   range.

Please help review and provide feedback.

Cheers,
Ashok Raj & Shaohua Li
