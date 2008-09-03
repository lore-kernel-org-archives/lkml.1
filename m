Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYICN7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYICN7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 09:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYICN7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 09:59:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43505 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbYICN7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 09:59:14 -0400
Message-ID: <48BE982C.20705@garzik.org>
Date: Wed, 03 Sep 2008 09:59:08 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: mingo@elte.hu, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net, akpm@linux-foundation.org,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [NET-NEXT PATCH] e1000: remove unused Kconfig option for disabling
 packet split
References: <20080827081956.11114.152.stgit@jtkirshe-mobile.jf.intel.com>
In-Reply-To: <20080827081956.11114.152.stgit@jtkirshe-mobile.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Kirsher wrote:
> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> 
> Since the e1000/e1000e split, no hardware supported by e1000
> supports packet split, just remove the Kconfig option and associated
> code from arch/* and the driver.
> 
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
> 
>  arch/arm/configs/iop13xx_defconfig              |    1 
>  arch/arm/configs/iop32x_defconfig               |    1 
>  arch/arm/configs/iop33x_defconfig               |    1 
>  arch/arm/configs/ixp23xx_defconfig              |    1 
>  arch/arm/configs/kirkwood_defconfig             |    1 
>  arch/ia64/configs/generic_defconfig             |    1 
>  arch/ia64/configs/gensparse_defconfig           |    1 
>  arch/ia64/configs/tiger_defconfig               |    1 
>  arch/ia64/configs/zx1_defconfig                 |    1 
>  arch/mips/configs/mtx1_defconfig                |    1 
>  arch/parisc/configs/a500_defconfig              |    1 
>  arch/parisc/configs/c3000_defconfig             |    1 
>  arch/powerpc/configs/83xx/mpc832x_rdb_defconfig |    1 
>  arch/powerpc/configs/85xx/mpc8560_ads_defconfig |    1 
>  arch/powerpc/configs/85xx/mpc85xx_cds_defconfig |    1 
>  arch/powerpc/configs/85xx/tqm8548_defconfig     |    1 
>  arch/powerpc/configs/cell_defconfig             |    1 
>  arch/powerpc/configs/g5_defconfig               |    1 
>  arch/powerpc/configs/iseries_defconfig          |    1 
>  arch/powerpc/configs/maple_defconfig            |    1 
>  arch/powerpc/configs/pasemi_defconfig           |    1 
>  arch/powerpc/configs/ppc64_defconfig            |    1 
>  arch/powerpc/configs/ppc6xx_defconfig           |    1 
>  arch/powerpc/configs/prpmc2800_defconfig        |    1 
>  arch/powerpc/configs/pseries_defconfig          |    1 
>  arch/sh/configs/r7780mp_defconfig               |    1 
>  arch/sparc64/defconfig                          |    1 
>  arch/x86/configs/i386_defconfig                 |    1 
>  arch/x86/configs/x86_64_defconfig               |    1 
>  drivers/net/Kconfig                             |    9 
>  drivers/net/e1000/e1000.h                       |   17 -
>  drivers/net/e1000/e1000_main.c                  |  416 -----------------------
>  32 files changed, 9 insertions(+), 462 deletions(-)

ACK, except for the defconfig changes.  arch maintainers usually prefer 
to do that themselves.

We'd be continually patch defconfig files, if we did so every time it 
was likely one would be updated by a Kconfig patch.


