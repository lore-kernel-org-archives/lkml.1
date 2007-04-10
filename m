Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbXDJIew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbXDJIew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 04:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbXDJIew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 04:34:52 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33728 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbXDJIev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 04:34:51 -0400
Message-ID: <461B4C28.4010806@garzik.org>
Date: Tue, 10 Apr 2007 04:34:48 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/8] [Intel IOMMU] Support for Intel Virtualization	Technology
 for Directed I/O
References: <20070409215552.221374000@intel.com>	 <461B4925.9080005@garzik.org> <1176193673.6781.24.camel@sli10-conroe.sh.intel.com>
In-Reply-To: <1176193673.6781.24.camel@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
> DMA remapping just uses ACPI table to tell which dma remapping engine a
> pci device is controlled by at boot time. At run time, DMA remapping
> hasn't any interactive with ACPI.

The Linux kernel _really_ wants a non-ACPI way to detect this.

Just use the hardware registers themselves, you don't need an ACPI table.

	Jeff


