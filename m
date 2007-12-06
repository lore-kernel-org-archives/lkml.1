Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbXLFWjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbXLFWjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 17:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbXLFWjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 17:39:10 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60635 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755961AbXLFWjH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 17:39:07 -0500
Date: Thu, 6 Dec 2007 14:37:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: linux-kernel@vger.kernel.org, Miles Lane <miles.lane@gmail.com>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc4-mm1: VDSOSYM build error
Message-Id: <20071206143754.07a67819.akpm@linux-foundation.org>
In-Reply-To: <47587796.8020705@free.fr>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	<47587796.8020705@free.fr>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Dec 2007 23:28:38 +0100
Laurent Riffard <laurent.riffard@free.fr> wrote:

> Le 05.12.2007 06:17, Andrew Morton a écrit :
> > Temporarily at
> >   http://userweb.kernel.org/~akpm/2.6.24-rc4-mm1/
> > Will appear later at
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/
> 
>   LDS     arch/x86/vdso/vdso32/vdso32.lds
>   AS      arch/x86/vdso/vdso32/note.o
>   AS      arch/x86/vdso/vdso32/int80.o
>   VDSO    arch/x86/vdso/vdso32-int80.so.dbg
>   OBJCOPY arch/x86/vdso/vdso32-int80.so
>   AS      arch/x86/vdso/vdso32/sysenter.o
>   VDSO    arch/x86/vdso/vdso32-sysenter.so.dbg
>   OBJCOPY arch/x86/vdso/vdso32-sysenter.so
>   AS      arch/x86/vdso/vdso32.o
>   CC      arch/x86/vdso/vdso32-setup.o
>   VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
>   VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
>   VDSOSYM arch/x86/vdso/vdso32-syms.lds
> --- -   2007-12-06 23:23:08.785302925 +0100
> +++ arch/x86/vdso/vdso32-int80-syms.lds 2007-12-06 23:23:08.000000000 +0100
> @@ -3,4 +3,3 @@
>  VDSO32_sigreturn = 0x0400;
>  VDSO32_vsyscall = 0x0414;
>  VDSO32_vsyscall_eh_frame_size = 0x044;
> -VDSO32_vsyscall_eh_frame_size = 0x058;
> make[1]: *** [arch/x86/vdso/vdso32-syms.lds] Error 1
> make: *** [arch/x86/vdso] Error 2

Dunno.  Maybe Roland's VDSO rework?
