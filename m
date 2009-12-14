Return-Path: <linux-kernel-owner+w=401wt.eu-S1750879AbZLNFHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750879AbZLNFHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 00:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZLNFHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 00:07:21 -0500
Received: from mga03.intel.com ([143.182.124.21]:55261 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbZLNFHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 00:07:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="222421385"
Subject: Re: [git pull] PCI changes for 2.6.33
From: Lin Ming <ming.m.lin@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Brown, Len" <len.brown@intel.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0912111216431.3560@localhost.localdomain>
References: <20091211110222.0ae1d897@jbarnes-piketon>
	 <alpine.LFD.2.00.0912111216431.3560@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 14 Dec 2009 12:51:54 +0800
Message-Id: <1260766314.3834.3.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-12-12 at 04:22 +0800, Linus Torvalds wrote:
> 
> On Fri, 11 Dec 2009, Jesse Barnes wrote:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 linux-next
> > 
> > I've got a section mismatch in here, but the fix will be part of the next
> > pull req (updated patch just came in recently).
> > 
> > Probably the biggest change here (at least my change count) is Bjorn's
> > MMCONFIG rework.  It sets the stage for hot plugging of host bridges and
> > _CBA and includes some nice cleanups besides.
> 
> Ok, so I got a few conflicts with the iommu/dmar changes (ACS related 
> changes versus the iommu_init changes) and with the ACPICA update 
> (acpi_walk_namespace() change in acpiphp_glue - it now takes a post-order 
> callback too).
> 
> I resolved them all, hopefully even correctly, but people should look over 
> the end result.

I checked all calls of acpi_walk_namespace in
drivers/pci/hotplug/acpiphp_glue.c.
All are correct.

Thanks,
Lin Ming

