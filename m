Return-Path: <linux-kernel-owner+w=401wt.eu-S1758820AbYJMSgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820AbYJMSgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbYJMSgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:36:07 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53258 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbYJMSgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:36:06 -0400
Date: Mon, 13 Oct 2008 21:35:03 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Brice Goglin <brice@myri.com>
Cc: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Jeff Garzik <jgarzik@redhat.com>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       linux-kernel@vger.kernel.org, apw@shadowen.org, linuxppc-dev@ozlabs.org,
       sam@ravnborg.org, e1000-devel@lists.sourceforge.net,
       netdev@vger.kernel.org,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: Re: [BUILD_FAILURE] 2.6.27-git2 - allyesconfig on powerpc
	selectsCONFIG_INTEL_IOATDMA=y
Message-ID: <20081013183503.GA28133@cs181140183.pp.htv.fi>
References: <20081013101559.GA14372@linux.vnet.ibm.com> <20081013112631.GD29938@cs181140183.pp.htv.fi> <36D9DB17C6DE9E40B059440DB8D95F52066E2EAE@orsmsx418.amr.corp.intel.com> <48F391B9.1000206@myri.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48F391B9.1000206@myri.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 08:21:45PM +0200, Brice Goglin wrote:
> Brandeburg, Jesse wrote:
> > What we want, is myri10ge and ixgbe drivers that can build whether or not CONFIG_INTEL_IOATDMA is enabled.  IF CONFIG_INTEL_IOATDMA *is* enabled (which it should not be on PPC) then there are several cases we want to work:
> > CONFIG_INTEL_IOATDMA=m  ---> CONFIG_IXGBE=[m|n]
> > CONFIG_INTEL_IOATDMA=y  ---> CONFIG_IXGBE=[m|y|n]
> > CONFIG_INTEL_IOATDMA=n  ---> CONFIG_IXGBE=[m|y|n]
> > CONFIG_INTEL_IOATDMA depends on X86
> 
> I am not sure I want to prevent myri10ge=y just because ioatdma=m.
>...

Technically both solutions are possible, which to choose is just a 
policy decision you have to agree on.

In practice it will anyway only rarely matter.

But considering that igb is in a similar situation it would be nice if 
all 3 drivers would handle it the same way.

> Brice

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

