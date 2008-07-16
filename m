Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbYGPMul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbYGPMul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 08:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbYGPMud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 08:50:33 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:60489 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbYGPMuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 08:50:32 -0400
Cc: Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Dave Jones <davej@redhat.com>,
       akpm <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Message-Id: <3C858BBD-6F6C-4539-BA49-AE123AFA5C5E@freescale.com>
From: Kumar Gala <kumar.gala@freescale.com>
To: benh@kernel.crashing.org
In-Reply-To: <1216206824.7740.172.camel@pasglop>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [git pull] Please pull from powerpc.git merge branch
Date: Wed, 16 Jul 2008 07:48:54 -0500
References: <1216172043.7740.136.camel@pasglop> <20080716042042.GA13212@redhat.com> <200807161051.12545.arnd@arndb.de> <1216206824.7740.172.camel@pasglop>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 16, 2008, at 6:13 AM, Benjamin Herrenschmidt wrote:

> On Wed, 2008-07-16 at 10:51 +0200, Arnd Bergmann wrote:
>> On Wednesday 16 July 2008, Dave Jones wrote:
>>> arch/powerpc/platforms/built-in.o: In function `ep8248e_mdio_probe':
>>> /builddir/build/BUILD/kernel-2.6.26/linux-2.6.26.ppc/arch/powerpc/ 
>>> platforms/82xx/ep8248e.c:129: undefined reference to  
>>> `alloc_mdio_bitbang'
>>> /builddir/build/BUILD/kernel-2.6.26/linux-2.6.26.ppc/arch/powerpc/ 
>>> platforms/82xx/ep8248e.c:143: undefined reference to  
>>> `mdiobus_register'
>>
>> FS_ENET and EP8248E both select MDIO_BITBANG, but not PHYLIB or  
>> MII, which
>> looks broken to me.
>>
>> Also, I think it would be useful to split out the bitbang
>> driver from ep8248e.c, so that you can build it as a loadable
>> module if you want to have PHYLIB loadable.
>
> On that note... I already run it through an autobuilder with a bunch  
> of
> configs before uploading (though obviously not this one). Kumar, can  
> you
> send me 2 or 3 configs you believe cover a reasonable range of the fsl
> stuff that I could stick into my list for next time ?

For e500/85xx use the mpc85xx_defconfig that is in the kernel.  I want  
to add a ppc6xx_defconfig to cover all 6xx based platforms that are  
reasonable (all that are cache coherent to it will exclude 51xx).

We are using mpc885_ads_defconfig for 8xx right now.

- k
