Return-Path: <linux-kernel-owner+w=401wt.eu-S1031106AbXDJQpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031106AbXDJQpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031107AbXDJQpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:45:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:46134 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031106AbXDJQpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:45:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,390,1170662400"; 
   d="scan'208"; a="225008976:sNHT6202631771"
Date: Tue, 10 Apr 2007 09:43:26 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Shaohua Li <shaohua.li@intel.com>, Ashok Raj <ashok.raj@intel.com>,
       linux-kernel@vger.kernel.org, akpm@osdl.org, ak@suse.de, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/8] [Intel IOMMU] Support for Intel Virtualization	Technology for Directed I/O
Message-ID: <20070410164325.GD31505@linux-os.sc.intel.com>
References: <20070409215552.221374000@intel.com> <461B4925.9080005@garzik.org> <1176193673.6781.24.camel@sli10-conroe.sh.intel.com> <461B4C28.4010806@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461B4C28.4010806@garzik.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 04:34:48AM -0400, Jeff Garzik wrote:
> Shaohua Li wrote:
> >DMA remapping just uses ACPI table to tell which dma remapping engine a
> >pci device is controlled by at boot time. At run time, DMA remapping
> >hasn't any interactive with ACPI.
> 
> The Linux kernel _really_ wants a non-ACPI way to detect this.
> 
> Just use the hardware registers themselves, you don't need an ACPI table.
> 
> 	Jeff

ACPI is required just not for identifying the DMA remapping hardware in the
system. We also need them to identify which engines control which pci devices.

Also there are some reserved sections that BIOS uses for its purpose that it
needs identity map.. say for legacy emulation via usb etc that needs
to be passed to the OS. 

not sure we can get away from using ACPI that easily.. its just only for setup
information, once the identification is complete we dont bother ACPI anymore.
