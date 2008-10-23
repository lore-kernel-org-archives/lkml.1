Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbYJWOiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbYJWOiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbYJWOiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:38:13 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:49411 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbYJWOiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:38:13 -0400
Date: Thu, 23 Oct 2008 16:38:10 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: include/linux/mmzone.h:288: error: 'CONFIG_NR_CPUS'
 undeclared here (not in a function)
In-Reply-To: <20081023122214.GA15805@x200.localdomain>
Message-ID: <Pine.LNX.4.64.0810231637400.18978@anakin>
References: <20081023213637.eff9b414.sfr@canb.auug.org.au>
 <20081023122214.GA15805@x200.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008, Alexey Dobriyan wrote:
> On avr32-debug-n-preempt-n:
> 
>   Using /src/linux-1 as source for kernel
>   GEN     /src/build/avr32-debug-n-preempt-n/Makefile
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CC      arch/avr32/kernel/asm-offsets.s
> In file included from /src/linux-1/include/linux/gfp.h:4,
>                  from /src/linux-1/include/linux/mm.h:8,
>                  from /src/linux-1/arch/avr32/kernel/asm-offsets.c:7:
> /src/linux-1/include/linux/mmzone.h:288: error: 'CONFIG_NR_CPUS' undeclared here (not in a function)
> In file included from /src/linux-1/include/linux/topology.h:30,
>                  from /src/linux-1/include/linux/mmzone.h:763,
>                  from /src/linux-1/include/linux/gfp.h:4,
>                  from /src/linux-1/include/linux/mm.h:8,
>                  from /src/linux-1/arch/avr32/kernel/asm-offsets.c:7:
> /src/linux-1/include/linux/cpumask.h:117:5: warning: "CONFIG_NR_CPUS" is not defined
> /src/linux-1/include/linux/cpumask.h:164:5: warning: "CONFIG_NR_CPUS" is not defined
> /src/linux-1/include/linux/cpumask.h:238:5: warning: "CONFIG_NR_CPUS" is not defined
> In file included from /src/linux-1/include/linux/mm.h:15,
>                  from /src/linux-1/arch/avr32/kernel/asm-offsets.c:7:
> /src/linux-1/include/linux/mm_types.h:26:5: warning: "CONFIG_NR_CPUS" is not defined
> /src/linux-1/include/linux/mm_types.h:70:5: warning: "CONFIG_NR_CPUS" is not defined
> In file included from /src/linux-1/arch/avr32/include/asm/pgtable.h:14,
>                  from /src/linux-1/include/linux/mm.h:40,
>                  from /src/linux-1/arch/avr32/kernel/asm-offsets.c:7:
> /src/linux-1/include/linux/sched.h:354:5: warning: "CONFIG_NR_CPUS" is not defined
> In file included from /src/linux-1/arch/avr32/kernel/asm-offsets.c:7:
> /src/linux-1/include/linux/mm.h:922:5: warning: "CONFIG_NR_CPUS" is not defined
> make[2]: *** [arch/avr32/kernel/asm-offsets.s] Error 1
> make[1]: *** [prepare0] Error 2
> make: *** [sub-make] Error 2

Same on m68k: http://kisskb.ellerman.id.au/kisskb/buildresult/50671/

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
