Return-Path: <linux-kernel-owner+w=401wt.eu-S1031276AbXDZPcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031276AbXDZPcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031290AbXDZPco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:32:44 -0400
Received: from amsfep19-int.chello.nl ([213.46.243.16]:54683 "EHLO
	amsfep11-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1031276AbXDZPco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:32:44 -0400
Subject: Re: linux-2.6.21 and __udivid3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: l l <happyarch@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <768a59a70704260824s584bb20fs8d4554dcca2d4c27@mail.gmail.com>
References: <768a59a70704260824s584bb20fs8d4554dcca2d4c27@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 17:32:39 +0200
Message-Id: <1177601559.24664.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 00:24 +0900, l l wrote:
> Hi,
> 
> How to link libgcc.a with linux-2.6.21?

you don't, in kernel one is supposed to used do_div() for 64/32.

>   LD      .tmp_vmlinux1
> kernel/built-in.o: In function `timespec_add_ns':
> /usr/src/linux-2.6.21/kernel/timer.c:828: undefined reference to `__udivdi3'
> /usr/src/linux-2.6.21/kernel/timer.c:841: undefined reference to `__udivdi3'
> /usr/src/linux-2.6.21/kernel/timer.c:1311: undefined reference to `__udivdi3'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make[1]: Leaving directory `/usr/src/linux-2.6.21'
> make: *** [debian/stamp-build-kernel] Error 2

I'm not seeing any /s there about. Is this a pristine tree?

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
> 
> TIA
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

