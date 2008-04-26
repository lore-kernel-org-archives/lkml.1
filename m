Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbYDZLnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbYDZLnd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 07:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYDZLnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 07:43:25 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50156 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbYDZLnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 07:43:25 -0400
Date: Sat, 26 Apr 2008 14:43:02 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       thomas@winischhofer.net
Subject: Re: [REGRESSEION] x86: allyesconfig fails with 'debug' symbol
Message-ID: <20080426114302.GD2252@cs181133002.pp.htv.fi>
References: <48131440.8090609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48131440.8090609@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 03:38:40PM +0400, Dmitri Vorobiev wrote:
> Hi,
> 
> The last commit as of writing this regression report is
> b1721d0da266b4af8cb4419473b4ca36206ab200, and I'm using Linus tree.
> 
> The allyesconfig build fails with the following error:
> 
> [dmitri.vorobiev@amber linux-2.6]$ make ARCH=i386 CROSS_COMPILE=i386-linux-gnu- 
> 
> [ ... skipped ... ]
> 
>   LD      vmlinux.o
> drivers/built-in.o: In function `SiS_EnableBridge':
> /home/dmitri.vorobiev/Projects/misc/zoo/src/linux-2.6/drivers/video/sis/init301.c:4352: multiple definition of `debug'
> arch/x86/kernel/built-in.o:/home/dmitri.vorobiev/Projects/misc/zoo/src/linux-2.6/arch/x86/kernel/entry_32.S:766: first defined here
> i386-linux-gnu-ld: Warning: size of symbol `debug' changed from 76 in arch/x86/kernel/built-in.o to 4 in drivers/built-in.o
> make: *** [vmlinux.o] Error 1
> [dmitri.vorobiev@amber linux-2.6]$
> 
> Although it is obvious what causes this problem, just now I have no time
> to try to resolve this, so I decided to just report the failure.

Fix:
  http://lkml.org/lkml/2008/4/25/376

> Thanks,
> Dmitri

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

