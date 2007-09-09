Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbXIILRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbXIILRE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 07:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbXIILQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 07:16:55 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:46073 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbXIILQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 07:16:54 -0400
Date: Sun, 9 Sep 2007 14:16:19 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: akpm@osdl.org, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       kristen.c.accardi@intel.com
Subject: Re: [RFC][Intel-IOMMU] Fix for IOMMU early crash
Message-ID: <20070909111619.GF31099@rhun.haifa.ibm.com>
References: <20070908200523.GA16204@askeshav-devel.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070908200523.GA16204@askeshav-devel.jf.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2007 at 01:05:24PM -0700, Keshavamurthy, Anil S wrote:

> Subject: [RFC][Intel-IOMMU] Fix for IOMMU early crash

This patch feels like a huge hack. See below.

> This patch removes sysdata from pci_dev struct and creates a new
> field called sys_data which is exclusively used by IOMMU driver to
> keep its per device context pointer.

Hmpf, why is this needed? with the pci_sysdata work that recently went
into mainline we have a void *iommu member in pci_sysdata which should
be all that's needed. Please elaborate if it's not enough for your
needs.

Thanks,
Muli
