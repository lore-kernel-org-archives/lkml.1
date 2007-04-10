Return-Path: <linux-kernel-owner+w=401wt.eu-S932966AbXDJDlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbXDJDlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 23:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932997AbXDJDli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 23:41:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:45708 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932966AbXDJDlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 23:41:37 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Ashok Raj <ashok.raj@intel.com>
Subject: Re: [patch 1/8] [Intel IOMMU] ACPI support for Intel Virtualization Technology for Directed I/O
Date: Mon, 9 Apr 2007 23:39:19 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, ak@suse.de, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
References: <20070409215552.221374000@intel.com> <20070409215723.248187000@intel.com>
In-Reply-To: <20070409215723.248187000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704092339.19923.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2007 17:55, Ashok Raj wrote:
> This patch contains basic ACPI parsing and enumeration support.

AFAICS, ACPI supplies the envelope which delivers the table,
and ACPI has some convenience structure definitions for that
table in include/acpi/actbl1.h (primarily for the acpixtract table dis-assembler),
but ACPI is otherwise not involved in IOMMU support.

Indeed, one might argue that all new functions in this patch series with
"acpi..." would more appropriately be called "pci...", since a cursory
scan of the IOMMU spec seems to suggest it is specific to PCI.

So on first blush, it looks like the only call to a function that begins with
"acpi" in this patch series should be acpi_get_table() from some IOMMU
specific file outside of drivers/acpi,
and the only modification to any code with an "acpi" in the file path or filename should
be any updates to the convenience structure definitions in acpitbl1.h

thanks,
-Len
