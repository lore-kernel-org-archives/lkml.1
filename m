Return-Path: <linux-kernel-owner+w=401wt.eu-S1759919AbYHFRch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919AbYHFRch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 13:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbYHFRag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 13:30:36 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59556 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235AbYHFRaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 13:30:35 -0400
Date: Wed, 6 Aug 2008 20:29:06 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: lethal@linux-sh.org, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: rsk7203_defconfig build error
Message-ID: <20080806172906.GB11188@cs181140183.pp.htv.fi>
References: <20080805154429.GD22895@cs181140183.pp.htv.fi> <87sktjw6sh.wl%ysato@users.sourceforge.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87sktjw6sh.wl%ysato@users.sourceforge.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 04:22:54PM -0400, Yoshinori Sato wrote:
> At Tue, 5 Aug 2008 18:44:29 +0300,
> Adrian Bunk wrote:
> > 
> > Hi Paul,
> > 
> > rsk7203_defconfig fails to build with the following error:
> > 
> > <--  snip  -->
> > 
> > ...
> >   LD      .tmp_vmlinux1
> > arch/sh/kernel/built-in.o:(__ksymtab+0xb8): undefined reference to `__udivsi3_i4i'
> > arch/sh/kernel/built-in.o:(__ksymtab+0xc8): undefined reference to `__sdivsi3_i4i'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > 
> > <--  snip  -->
> > 
> > That worked with 2.6.26, and these are far less undefined references 
> > than in the cases where libgcc was missing.
> 
> This functions is not defined sh2 and sh2a.
> See gcc-4.3.1/gcc/config/sh/lib1funcs.asm
> 
> Sorry I forget report.
> 
> This patch not tested.
> Please test and apply.
>...

Thanks, that fixed the compilation for me.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

