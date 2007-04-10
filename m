Return-Path: <linux-kernel-owner+w=401wt.eu-S966113AbXDJIWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966113AbXDJIWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 04:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966110AbXDJIWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 04:22:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33644 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966113AbXDJIWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 04:22:06 -0400
Message-ID: <461B4925.9080005@garzik.org>
Date: Tue, 10 Apr 2007 04:21:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ashok Raj <ashok.raj@intel.com>
CC: linux-kernel@vger.kernel.org, akpm@osdl.org, ak@suse.de, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/8] [Intel IOMMU] Support for Intel Virtualization Technology
 for Directed I/O
References: <20070409215552.221374000@intel.com>
In-Reply-To: <20070409215552.221374000@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ashok Raj wrote:
> 1. Support for ACPI framework to parse and work with DMA Remapping Tables.
> 2. Add support for PCI infrastructure to search parent relationships.
> 3. Hardware support for providing DMA remapping support for Intel Chipsets.
> 4. Supporting Zero Length Reads on DMAR's not able to support ZLR.
> 5. Graphics driver workarounds to provide unity map since they dont use dma api.
> 6. Updates to Documentation area for startup options and some basics.
> 7. Workaround to provide unity map for ISA bridge device to enable floppy disk.
> 8. Ability to preserve some mappings for devices not able to address entire 
>    range.

I really think it would be best to avoid ACPI for something as critical 
as DMA remapping!

	Jeff


