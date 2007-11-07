Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbXKGV47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbXKGV47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 16:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbXKGV4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 16:56:50 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41911 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754253AbXKGV4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 16:56:49 -0500
Date: Wed, 7 Nov 2007 13:55:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       k.shutemov@gmail.com, apw@shadowen.org
Subject: Re: mm snapshot broken-out-2007-11-06-02-32 make header check fails
Message-Id: <20071107135537.08ece5bb.akpm@linux-foundation.org>
In-Reply-To: <47322340.702@linux.vnet.ibm.com>
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
	<47322340.702@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 08 Nov 2007 02:12:40 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> Hi Andrew,
> 
> The build fails with error
> 
>   CHECK   include/asm-generic/siginfo.h
>   CHECK   include/asm-generic/resource.h
>   CHECK   include/asm-generic/statfs.h
>   CHECK   include/asm-generic/signal.h
>   CHECK   include/asm-generic/poll.h
>   CHECK   include/asm-generic/mman.h
>   CHECK   include/asm-generic/ioctl.h
>   CHECK   include/asm-generic/fcntl.h
>   CHECK   include/asm-generic/errno.h
>   CHECK   include/asm-generic/errno-base.h
>   CHECK   include/asm/cputable.h
>   CHECK   include/asm/byteorder.h
>   CHECK   include/asm/bootx.h
>   CHECK   include/asm/auxvec.h
>   CHECK   include/asm/asm-compat.h
>   CHECK   include/asm/a.out.h
>   CHECK   include/asm/ucontext.h
>   CHECK   include/asm/ps3fb.h
>   CHECK   include/asm/linkage.h
>   CHECK   include/asm/elf.h
> /home/test/kernels/linux-2.6.24-rc1/patches/linux-2.6.24-rc1/usr/include/asm/elf.h requires asm/page.h, which does not exist in exported headers
> make[3]: *** [/home/test/kernels/linux-2.6.24-rc1/patches/linux-2.6.24-rc1/usr/include/asm/.check.elf.h] Error 1
> make[2]: *** [asm-powerpc] Error 2
> make[1]: *** [headers_check] Error 2
> make: *** [vmlinux] Error 2
> 

I am going to guess that you're building for powerpc here.

It looks like ia64 broke too.  I'll drop the patch, thanks.
