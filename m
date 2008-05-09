Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbYEIJCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbYEIJCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 05:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbYEIJCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 05:02:40 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:35165 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbYEIJCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 05:02:39 -0400
Date: Fri, 9 May 2008 12:01:07 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org, shemminger@linux-foundation.org
Subject: Re: build issue #349 for v2.6.26-rc1-279-g28a4acb :
Message-ID: <20080509090107.GN22887@cs181133002.pp.htv.fi>
References: <200805091033.55132.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805091033.55132.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 10:33:52AM +0200, Toralf Förster wrote:
> Hello,
> 
> the build (.config attached) failed, make ends with :
> ...
>   CC      arch/x86/lib/usercopy_32.o
>   AR      arch/x86/lib/lib.a
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: modpost: Found 1 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `apanel_detach_client':
> apanel.c:(.text+0x105506): undefined reference to `led_classdev_unregister'
> drivers/built-in.o: In function `apanel_probe':
> apanel.c:(.text+0x1057b9): undefined reference to `led_classdev_register'
> make: *** [.tmp_vmlinux1] Error 1
>...

Thanks for the report.

That's a known CONFIG_X86_RDC321X bug.

I'll check where the best fix by Roman is stuck.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

