Return-Path: <linux-kernel-owner+w=401wt.eu-S1760436AbYHAW06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760436AbYHAW06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbYHAW0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:26:50 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:51197 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbYHAW0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:26:49 -0400
Date: Sat, 2 Aug 2008 01:25:46 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Paul Mundt <lethal@linux-sh.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] sh: fix LIBGCC
Message-ID: <20080801222546.GJ19682@cs181140183.pp.htv.fi>
References: <20080801221344.GI19682@cs181140183.pp.htv.fi> <20080801222217.GD13448@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080801222217.GD13448@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2008 at 07:22:17AM +0900, Paul Mundt wrote:
> On Sat, Aug 02, 2008 at 01:13:44AM +0300, Adrian Bunk wrote:
> > Commit f15cbe6f1a4b4d9df59142fc8e4abb973302cf44
> > (sh: migrate to arch/sh/include/) moved KBUILD_CFLAGS
> > (which is used by LIBGCC) below LIBGCC, causing build
> > errors like the following:
> > 
> > <--  snip  -->
> > 
> > ...
> >   LD      .tmp_vmlinux1
> > arch/sh/kernel/built-in.o: In function `module_clk_recalc':
> > clock-sh4.c:(.text+0x80f0): undefined reference to `__udivsi3_i4i'
> > ...
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > 
> > <--  snip  -->
> > 
> > Reported-by: Adrian Bunk <bunk@kernel.org>
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> That's interesting, none of my compilers had difficulty with it, whereas
> it seems your toolchain couldn't report the libgcc location at all.
>...

It did report /usr/local/DIR/gcc-sh-4.3.1/lib/gcc/sh-linux/4.3.1/libgcc.a,
but that's not for all configurations the correct one.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

