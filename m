Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbYJ2KFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbYJ2KFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 06:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbYJ2KFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 06:05:14 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49672 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbYJ2KFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 06:05:12 -0400
Date: Wed, 29 Oct 2008 12:03:56 +0200
From: Adrian Bunk <bunk@kernel.org>
To: =?utf-8?B?UmHDumw=?= Porcel <armin76@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, klausman@gentoo.org,
       Arjan van de Ven <arjan@infradead.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [ALPHA] 2.6.28-rc fails to compile
Message-ID: <20081029100356.GA28224@cs181140183.pp.htv.fi>
References: <49083361.5060907@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49083361.5060907@gentoo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 10:56:49AM +0100, Raúl Porcel wrote:
> Hi,
> 
> I guess the git bisect says everything, but if you need more info,
> please say so.

Please send your .config

>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   HOSTCC  scripts/basic/fixdep
>   HOSTCC  scripts/basic/docproc
>   HOSTCC  scripts/basic/hash
>   CC      kernel/bounds.s
>   GEN     include/linux/bounds.h
>   CC      arch/alpha/kernel/asm-offsets.s
> In file included from
> /usr/src/linux-2.6.28-rc2/arch/alpha/include/asm/core_tsun
> ami.h:5,
>                  from
> /usr/src/linux-2.6.28-rc2/arch/alpha/include/asm/io.h:232,
>                  from arch/alpha/kernel/asm-offsets.c:12:
> include/linux/pci.h: In function 'pci_ioremap_bar':
> include/linux/pci.h:1148: error: implicit declaration of function
> 'ioremap_nocac
> he'
> include/linux/pci.h:1149: warning: return makes pointer from integer
> without a c
> ast
> In file included from arch/alpha/kernel/asm-offsets.c:12:
> /usr/src/linux-2.6.28-rc2/arch/alpha/include/asm/io.h: At top level:
> /usr/src/linux-2.6.28-rc2/arch/alpha/include/asm/io.h:300: error:
> conflicting ty
> pes for 'ioremap_nocache'
> include/linux/pci.h:1148: error: previous implicit declaration of
> 'ioremap_nocac
> he' was here
> make[1]: *** [arch/alpha/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2
> 
> 
> -------------------------
> 
> aa42d7c6138afdc54f74e971456a0fbfec16b77b is first bad commit
> commit aa42d7c6138afdc54f74e971456a0fbfec16b77b
> Author: Arjan van de Ven <arjan@infradead.org>
> Date:   Sun Sep 28 16:36:11 2008 -0700
> 
>     PCI: introduce an pci_ioremap(pdev, barnr) function

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

