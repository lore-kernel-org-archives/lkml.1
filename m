Return-Path: <linux-kernel-owner+w=401wt.eu-S1031364AbXDZRzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031364AbXDZRzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031376AbXDZRzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:55:17 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35490 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031364AbXDZRzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:55:16 -0400
Date: Thu, 26 Apr 2007 19:55:26 +0200
From: Adrian Bunk <bunk@stusta.de>
To: l l <happyarch@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.21 and __udivid3
Message-ID: <20070426175526.GR3468@stusta.de>
References: <768a59a70704260824s584bb20fs8d4554dcca2d4c27@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <768a59a70704260824s584bb20fs8d4554dcca2d4c27@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 12:24:32AM +0900, l l wrote:
> Hi,
>
> How to link libgcc.a with linux-2.6.21?
>
>  LD      .tmp_vmlinux1
> kernel/built-in.o: In function `timespec_add_ns':
> /usr/src/linux-2.6.21/kernel/timer.c:828: undefined reference to 
> `__udivdi3'
> /usr/src/linux-2.6.21/kernel/timer.c:841: undefined reference to 
> `__udivdi3'
> /usr/src/linux-2.6.21/kernel/timer.c:1311: undefined reference to 
> `__udivdi3'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make[1]: Leaving directory `/usr/src/linux-2.6.21'
> make: *** [debian/stamp-build-kernel] Error 2

I assume this is a plain 2.6.21 from ftp.kernel.org?

> cc -v
> Using built-in specs.
> Target: i686-pc-linux-gnu
> Configured with: ../gcc/configure --prefix=/usr --libexecdir=/usr/lib
> --enable-shared --enable-threads=posix --enable-__cxa_atexit
> --enable-clocale=gnu --enable-languages=c,c++,treelang
> --with-system-zlib --with-gmp --enable-mpfr
> --enable-libstdcxx-allocator=mt
> Thread model: posix
> gcc version 4.3.0 20070420 (experimental)

Can you reproduce this with gcc 4.1?
If yes, please send your .config .

> TIA

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

