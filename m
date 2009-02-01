Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbZBAKkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbZBAKkY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 05:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbZBAKkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 05:40:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33144 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbZBAKkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 05:40:05 -0500
Date: Sun, 1 Feb 2009 11:39:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       hskinnemoen@atmel.com, cooloney@kernel.org, tony.luck@intel.com,
       ralf@linux-mips.org, dhowells@redhat.com, matthew@wil.cx,
       chris@zankel.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull -tip] headers_check fixes for other architectures
Message-ID: <20090201103936.GA30157@elte.hu>
References: <1233385816.17794.16.camel@localhost.localdomain> <20090131164410.GA11189@elte.hu> <1233469811.5846.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233469811.5846.14.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Sat, 2009-01-31 at 17:44 +0100, Ingo Molnar wrote:
> 
> > Then you can git-cherry-pick all your new commits into that new tree, and 
> > send a pull request if you are happy with it. Likewise, you can probably 
> > achieve the same (with a lot less work) by doing this in your master 
> > branch above:
> 
> The following changes since commit 7e3fa56141175026136b392fd026d5d07c49720e:
>   Sam Ravnborg (1):
>         kbuild: drop check for CONFIG_ in headers_check
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git core/header-fixes
> 
> Jaswinder Singh Rajput (27):
>       headers_check fix: alpha, statfs.h
>       headers_check fix: alpha, swab.h
>       headers_check fix: arm, a.out.h
>       headers_check fix: arm, setup.h
>       headers_check fix: arm, swab.h
>       headers_check fix: avr32, swab.h
>       headers_check fix: blackfin, swab.h
>       headers_check fix: frv, swab.h
>       headers_check fix: h8300, swab.h
>       headers_check fix: ia64, fpu.h
>       headers_check fix: ia64, gcc_intrin.h
>       headers_check fix: ia64, intrinsics.h
>       headers_check fix: ia64, kvm.h
>       headers_check fix: ia64, swab.h
>       headers_check fix: m32r, swab.h
>       headers_check fix: mips, sigcontext.h
>       headers_check fix: mips, swab.h
>       headers_check fix: mn10300, swab.h
>       headers_check fix: parisc, pdc.h
>       headers_check fix: parisc, swab.h
>       headers_check fix: powerpc, bootx.h
>       headers_check fix: powerpc, elf.h
>       headers_check fix: powerpc, kvm.h
>       headers_check fix: powerpc, ps3fb.h
>       headers_check fix: powerpc, spu_info.h
>       headers_check fix: powerpc, swab.h
>       headers_check fix: xtensa, swab.h
> 
>  arch/alpha/include/asm/statfs.h     |    2 ++
>  arch/alpha/include/asm/swab.h       |    2 +-
>  arch/arm/include/asm/a.out.h        |    2 +-
>  arch/arm/include/asm/setup.h        |    2 +-
>  arch/arm/include/asm/swab.h         |    2 +-
>  arch/avr32/include/asm/swab.h       |    2 +-
>  arch/blackfin/include/asm/swab.h    |    2 +-
>  arch/h8300/include/asm/swab.h       |    2 +-
>  arch/ia64/include/asm/fpu.h         |    2 +-
>  arch/ia64/include/asm/gcc_intrin.h  |    1 +
>  arch/ia64/include/asm/intrinsics.h  |    1 +
>  arch/ia64/include/asm/kvm.h         |    3 +--
>  arch/ia64/include/asm/swab.h        |    2 +-
>  arch/mips/include/asm/sigcontext.h  |    1 +
>  arch/mips/include/asm/swab.h        |    2 +-
>  arch/parisc/include/asm/pdc.h       |    3 ++-
>  arch/parisc/include/asm/swab.h      |    2 +-
>  arch/powerpc/include/asm/bootx.h    |    2 +-
>  arch/powerpc/include/asm/elf.h      |    2 +-
>  arch/powerpc/include/asm/kvm.h      |    2 +-
>  arch/powerpc/include/asm/ps3fb.h    |    1 +
>  arch/powerpc/include/asm/spu_info.h |    3 ++-
>  arch/powerpc/include/asm/swab.h     |    2 +-
>  arch/xtensa/include/asm/swab.h      |    2 +-
>  include/asm-frv/swab.h              |    2 +-
>  include/asm-m32r/swab.h             |    2 +-
>  include/asm-mn10300/swab.h          |    2 +-
>  27 files changed, 30 insertions(+), 23 deletions(-)
> 
> These patches fixes 41 headers_check warnings as shown in first email.

Pulled into tip/core/header-fixes, thanks Jaswinder!

	Ingo
