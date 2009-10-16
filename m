Return-Path: <linux-kernel-owner+w=401wt.eu-S1751300AbZJPXlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbZJPXlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 19:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbZJPXlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 19:41:09 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:38254 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbZJPXlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 19:41:09 -0400
Message-Id: <1255736473.32403.1340525457@webmail.messagingengine.com>
X-Sasl-Enc: 9/SJizCelawBHekfMoOsTWpf7eCtqYzjrFQNgjiJmw1K 1255736473
From: myuboot@fastmail.fm
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <1255735395.30097.1340523469@webmail.messagingengine.com>
References: <1255735395.30097.1340523469@webmail.messagingengine.com>
Subject: Re: 2.6.31 kernel for mips compile failure - war.h:12:17: error: war.h:
 No such file or directory
Date: Fri, 16 Oct 2009 18:41:13 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I need to take the question back. I found war.h is a file I need
to created for my board. I forgot to copy it over. So no problem any
more.thanks.

On Fri, 16 Oct 2009 18:23 -0500, myuboot@fastmail.fm wrote:
> I am trying to use buildroot 2009.08 to compile kernel 2.6.31 for mips,
> but it fails to error -" war.h can't be found". I used the same
> buildroot to build kernel version 2.6.29 with no problem. 
> 
> Please give me some suggestion on how to fix this issue. The file 
> ./arch/mips/include/asm/war.h is there with no problem. Thanks a lot.
> 
> cp
> /home/root123/sources/buildroot-2009.08-k/build_mips/staging_dir/usr/bin/mkimage
> /home/root123/sources/buildroot-2009.08-k/project_build_mips/f1/u-boot-tools
> mkdir -p
> /home/root123/sources/buildroot-2009.08-k/project_build_mips/f1/root/boot
> mv
> /home/root123/sources/buildroot-2009.08-k/project_build_mips/f1/linux-2.6.31/localversion*
> /home/root123/sources/buildroot-2009.08-k/project_build_mips/f1/root/boot
> mv: cannot stat
> `/home/root123/sources/buildroot-2009.08-k/project_build_mips/f1/linux-2.6.31/localversion*':
> No such file or directory
> make:
> [/home/root123/sources/buildroot-2009.08-k/project_build_mips/f1/linux-2.6.31/.depend_done]
> Error 1 (ignored)
> /usr/bin/make -j1 HOSTCC="/usr/bin/gcc" HOSTCFLAGS="" ARCH=mips
> INSTALL_MOD_PATH=/home/root123/sources/buildroot-2009.08-k/project_build_mips/f1/root
> CROSS_COMPILE=/home/root123/sources/buildroot-2009.08-k/build_mips/staging_dir/usr/bin/mips-linux-uclibc-
> LDFLAGS="-L/home/root123/sources/buildroot-2009.08-k/build_mips/staging_dir/lib
> -L/home/root123/sources/buildroot-2009.08-k/build_mips/staging_dir/usr/lib
> --sysroot=/home/root123/sources/buildroot-2009.08-k/build_mips/staging_dir/"
> LZMA="/home/root123/sources/buildroot-2009.08-k/toolchain_build_mips/bin/lzma"
> PATH=/home/root123/sources/buildroot-2009.08-k/project_build_mips/f1/u-boot-tools:/home/root123/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/stuff/bitbake/bin
> -C
> /home/root123/sources/buildroot-2009.08-k/project_build_mips/f1/linux-2.6.31
> prepare
> make[1]: Entering directory
> `/home/root123/sources/buildroot-2009.08-k/project_build_mips/f1/linux-2.6.31'
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   SYMLINK include/asm -> include/asm-mips
>   CC      arch/mips/kernel/asm-offsets.s
> In file included from
> /home/root123/sources/buildroot-2009.08-k/project_build_mips/f1/linux-2.6.31/arch/mips/include/asm/bitops.h:24,
>                  from include/linux/bitops.h:17,
>                  from include/linux/kernel.h:15,
>                  from include/linux/sched.h:52,
>                  from arch/mips/kernel/asm-offsets.c:13:
> /home/root123/sources/buildroot-2009.08-k/project_build_mips/f1/linux-2.6.31/arch/mips/include/asm/war.h:12:17:
> error: war.h: No such file or directory
> /home/root123/sources/buildroot-2009.08-k/project_build_mips/f1/linux-2.6.31/arch/mips/include/asm/war.h:82:2:
> error: #error Check setting of R4600_V1_INDEX_ICACHEOP_WAR for your
> platform
> /home/root123/sources/buildroot-2009.08-k/project_build_mips/f1/linux-2.6.31/arch/mips/include/asm/war.h:112:2:
> error: #error Check setting of R4600_V1_HIT_CACHEOP_WAR for your
> platform
> /home/root123/sources/buildroot-2009.08-k/project_build_mips/f1/linux-2.6.31/arch/mips/include/asm/war.h:128:2:
> error: #error Check setting of R4600_V2_HIT_CACHEOP_WAR for your
> platform
> /home/root123/sources/buildroot-2009.08-k/project_build_mips/f1/linux-2.6.31/arch/mips/include/asm/war.h:141:2:
> error: #error Check setting of R5432_CP0_INTERRUPT_WAR foryour platform
> /home/root123/sources/buildroot-2009.08-k/project_build_mips/f1/linux-2.6.31/arch/mips/include/asm/war.h:155:2:
> error: #error Check setting of BCM1250_M3_WAR for your platform
> /home/root123/sources/buildroot-2009.08-k/project_build_mips/f1/linux-2.6.31/arch/mips/include/asm/war.h:162:2:
> error: #error Check setting of SIBYTE_1956_WAR for your platform
> /home/root123/sources/buildroot-2009.08-k/project_build_mips/f1/linux-2.6.31/arch/mips/include/asm/war.h:178:2:
> error: #error Check setting of MIPS4K_ICACHE_REFILL_WAR for your
> platform
