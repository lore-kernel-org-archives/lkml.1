Return-Path: <linux-kernel-owner+w=401wt.eu-S1764068AbYEGH7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764068AbYEGH7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYEGH71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:59:27 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:36784 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbYEGH7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:59:25 -0400
Date: Wed, 7 May 2008 10:58:09 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: irda-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: build issue #493 for v2.6.26-rc1-110-ga153063 :undefined
	reference to `pnp_get_resource'
Message-ID: <20080507075809.GA29935@cs181133002.pp.htv.fi>
References: <200805070947.35682.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805070947.35682.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 09:47:35AM +0200, Toralf Förster wrote:
> 
> the build (.config attached) failed, make ends with :
> ...
>   CHECK   include/video/sisfb.h
>   CHECK   include/video/edid.h
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      vmlinux
> drivers/built-in.o: In function `smsc_ircc_pnp_probe':
> smsc-ircc2.c:(.init.text+0x83fd): undefined reference to `pnp_get_resource'
> smsc-ircc2.c:(.init.text+0x8431): undefined reference to `pnp_get_resource'
> smsc-ircc2.c:(.init.text+0x8449): undefined reference to `pnp_get_resource'
> smsc-ircc2.c:(.init.text+0x8461): undefined reference to `pnp_get_resource'
> smsc-ircc2.c:(.init.text+0x8479): undefined reference to `pnp_get_resource'
> drivers/built-in.o:smsc-ircc2.c:(.init.text+0x848c): more undefined references to `pnp_get_resource' follow
> make: *** [vmlinux] Error 1
>...

Thanks for the report.

It should be fixed by a commit that just entered Linus' tree.

> MfG/Sincerely
> 
> Toralf Förster

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

