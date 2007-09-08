Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbXIGPjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbXIGPjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 11:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757550AbXIGPjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 11:39:17 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:26705 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757509AbXIGPjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 11:39:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hRltS5Ax9UMiu0Z6MNuMVo6NiP1LDiLubrwBHGuspCAvfy6Dfe6aMEX0IRjJhQIzGlmDlu2trHEKin3utHOw0igPnM4UXlWndu7ScU+jbiF9iOylC0DfcnXxZ18tqWgs2QlEUjIyUT3F5nbq9cz1xmrMZFRmjIcX/Zburs7WhQY=  ;
X-YMail-OSG: ZfI_7oEVM1mjF5I3le2SJCXTtGOvXpHCKrJUzzyV300team5Cs2X91Jsz5_xyWWSyqtlKS_sYw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc4-mm1 compile error for ppc 32
Date: Sat, 8 Sep 2007 11:36:46 +1000
User-Agent: KMail/1.9.5
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org
References: <20070906184011.GA1776@Krystal> <20070906160009.fa52e8d2.akpm@linux-foundation.org>
In-Reply-To: <20070906160009.fa52e8d2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709081136.46605.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2007 09:00, Andrew Morton wrote:
> > On Thu, 6 Sep 2007 14:40:11 -0400 Mathieu Desnoyers
> > <mathieu.desnoyers@polymtl.ca> wrote: Hi Andrew,
> >
> > Guess what, another one ;)
> >
> >  
> > /opt/crosstool/gcc-4.1.1-glibc-2.3.6/powerpc-405-linux-gnu/bin/powerpc-40
> >5-linux-gnu-gcc -m32 -Wp,-MD,arch/ppc/kernel/.asm-offsets.s.d  -nostdinc
> > -isystem
> > /opt/crosstool/gcc-4.1.1-glibc-2.3.6/powerpc-405-linux-gnu/lib/gcc/powerp
> >c-405-linux-gnu/4.1.1/include -D__KERNEL__ -Iinclude -Iinclude2
> > -I/home/compudj/git/linux-2.6-lttng/include -include
> > include/linux/autoconf.h -Iarch/ppc -Iarch/ppc/include
> > -I/home/compudj/git/linux-2.6-lttng/. -I. -Wall -Wundef
> > -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common
> > -Werror-implicit-function-declaration -Os
> > -I/home/compudj/git/linux-2.6-lttng/arch/ppc -Iarch/ppc -msoft-float
> > -pipe -ffixed-r2 -mmultiple -mno-altivec -mstring -Wa,-m405
> > -fomit-frame-pointer -g -fno-stack-protector
> > -Wdeclaration-after-statement -Wno-pointer-sign  -D"KBUILD_STR(s)=#s"
> > -D"KBUILD_BASENAME=KBUILD_STR(asm_offsets)" 
> > -D"KBUILD_MODNAME=KBUILD_STR(asm_offsets)" -fverbose-asm -S -o
> > arch/ppc/kernel/asm-offsets.s /home/compudj/git/linux-2.6-lttng/arc!
>
>  h/ppc/kernel/asm-offsets.c
>
> > In file included from
> > /home/compudj/git/linux-2.6-lttng/include/linux/bitops.h:17, from
> > /home/compudj/git/linux-2.6-lttng/include/linux/kernel.h:15, from
> > include2/asm/system.h:7,
> >                  from
> > /home/compudj/git/linux-2.6-lttng/include/linux/list.h:9, from
> > /home/compudj/git/linux-2.6-lttng/include/linux/signal.h:8, from
> > /home/compudj/git/linux-2.6-lttng/arch/ppc/kernel/asm-offsets.c:11:
> > arch/ppc/include/asm/bitops.h: In function '__clear_bit_unlock':
> > arch/ppc/include/asm/bitops.h:229: error: expected string literal before
> > ':' token arch/ppc/include/asm/bitops.h:229: confused by earlier errors,
> > bailing out make[2]: *** [arch/ppc/kernel/asm-offsets.s] Error 1
> > make[1]: *** [prepare0] Error 2
> > make: *** [_all] Error 2
>
> What the heck is arch/ppc/include/asm/bitops.h?  I assume that it's
> include/asm-powerpc/bitops.h via some wormhole.
>
>
> If so, the finger points at this:
>
> static __inline__ void __clear_bit_unlock(int nr, volatile unsigned long
> *addr) {
> 	__asm__ __volatile__(LWSYNC_ON_SMP ::: "memory");
> 	__clear_bit(nr, addr);
> }
>
> which was added by Nick's powerpc-lock-bitops.patch.  I am suspecting that
> this isn't pp32 code?

Hmm, when LWSYNC_ON_SMP is a noop, it seems like it should probably
be an empty string instead of nothing? ("") That should make behaviour
more consistent I think.

Ben?


> (what's with the newly-added old-style __inline__, btw?  That's just more
> stuff we need to clean up later, so there doesn't seem much point in adding
> it).

Consistency really. Otherwise people ask why I've done it differently :P I
don't suppose it makes a future cleanup any harder, while giving a better
result until then.
