Return-Path: <linux-kernel-owner+w=401wt.eu-S965838AbXDKBTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965838AbXDKBTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 21:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965578AbXDKBTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 21:19:09 -0400
Received: from smtp.osdl.org ([65.172.181.24]:54912 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964784AbXDKBTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 21:19:08 -0400
Date: Tue, 10 Apr 2007 18:18:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Subject: Re: Build error : 2.6.21-rc6-mm1 on sparc64
Message-Id: <20070410181854.7d532c59.akpm@linux-foundation.org>
In-Reply-To: <20070411004838.GD15262@Krystal>
References: <20070411004838.GD15262@Krystal>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 20:48:38 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> I get the following build error when building 2.6.21-rc6-mm1 for
> sparc64:
> 
>   /opt/crosstool/gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/bin/sparc64-unknown-linux-gnu-gcc -Wp,-MD,arch/sparc64/kernel/.traps.o.d  -nostdinc -isystem /opt/crosstool/gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/lib/gcc/sparc64-unknown-linux-gnu/3.4.5/include -D__KERNEL__ -Iinclude -Iinclude2 -I/home/compudj/git/linux-2.6-lttng/include -include include/linux/autoconf.h -I/home/compudj/git/linux-2.6-lttng/arch/sparc64/kernel -Iarch/sparc64/kernel -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Os -m64 -pipe -mno-fpu -mcpu=ultrasparc -mcmodel=medlow -ffixed-g4 -ffixed-g5 -fcall-used-g7 -Wno-sign-compare -Wa,--undeclared-regs -fomit-frame-pointer -Wdeclaration-after-statement -Werror  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(traps)"  -D"KBUILD_MODNAME=KBUILD_STR(traps)" -c -o arch/sparc64/kernel/traps.o /home/compudj/git/linux-2.6-lttng/arch/sparc64/kernel/traps.c
> /home/compudj/git/linux-2.6-lttng/arch/sparc64/kernel/traps.c: In function `init_cur_cpu_trap':
> /home/compudj/git/linux-2.6-lttng/arch/sparc64/kernel/traps.c:2497: warning: implicit declaration of function `hard_smp_processor_id'
> make[2]: *** [arch/sparc64/kernel/traps.o] Error 1
> make[1]: *** [arch/sparc64/kernel] Error 2
> make: *** [_all] Error 2

Not sure what the approved fix is here.  Fernando, please take a look, and
review all other architectures?

