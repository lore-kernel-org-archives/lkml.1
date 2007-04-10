Return-Path: <linux-kernel-owner+w=401wt.eu-S1031051AbXDJQ1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031051AbXDJQ1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031056AbXDJQ1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:27:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:42789 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031054AbXDJQ1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:27:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,390,1170662400"; 
   d="scan'208"; a="224994988:sNHT69722114"
Date: Tue, 10 Apr 2007 09:26:27 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
Subject: Re: [patch 1/8] [Intel IOMMU] ACPI support for Intel Virtualization Technology for Directed I/O
Message-ID: <20070410162626.GB31505@linux-os.sc.intel.com>
References: <20070409215552.221374000@intel.com> <20070409215723.248187000@intel.com> <200704092339.19923.lenb@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704092339.19923.lenb@kernel.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 11:39:19PM -0400, Len Brown wrote:
> On Monday 09 April 2007 17:55, Ashok Raj wrote:
> > This patch contains basic ACPI parsing and enumeration support.
> 
> AFAICS, ACPI supplies the envelope which delivers the table,
> and ACPI has some convenience structure definitions for that
> table in include/acpi/actbl1.h (primarily for the acpixtract table dis-assembler),
> but ACPI is otherwise not involved in IOMMU support.
> 
> Indeed, one might argue that all new functions in this patch series with
> "acpi..." would more appropriately be called "pci...", since a cursory
> scan of the IOMMU spec seems to suggest it is specific to PCI.

Think we can migrate some of the code to make the core part just perform
the get-table. We will do that in the next respin.

> 
> So on first blush, it looks like the only call to a function that begins with
> "acpi" in this patch series should be acpi_get_table() from some IOMMU
> specific file outside of drivers/acpi,
> and the only modification to any code with an "acpi" in the file path or filename should
> be any updates to the convenience structure definitions in acpitbl1.h
> 
> thanks,
> -Len
