Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbZC2Osh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbZC2Osh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 10:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757165AbZC2Os2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 10:48:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:38015 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756458AbZC2Os1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 10:48:27 -0400
Subject: Re: [PATCH -tip] x86: unification of module.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20090326223406.GB28755@elte.hu>
References: <1238072913.2507.3.camel@ht.satnam>
	 <alpine.LFD.2.00.0903261835020.3397@localhost.localdomain>
	 <20090326223406.GB28755@elte.hu>
Content-Type: text/plain
Date: Sun, 29 Mar 2009 20:17:31 +0530
Message-Id: <1238338051.2534.6.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-26 at 23:34 +0100, Ingo Molnar wrote:
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Thu, 26 Mar 2009, Jaswinder Singh Rajput wrote:
> > > This patch is based on -tip:x86/core:
> > > 
> > > From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > Date: Thu, 26 Mar 2009 18:33:45 +0530
> > > Subject: [PATCH] x86: unification of module.c
> > > 
> > > Impact: Unification, cleanup
> > > 
> > > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > ---
> > >  arch/x86/kernel/Makefile    |    2 +-
> > >  arch/x86/kernel/module.c    |  261 +++++++++++++++++++++++++++++++++++++++++++
> > >  arch/x86/kernel/module_32.c |  152 -------------------------
> > >  arch/x86/kernel/module_64.c |  194 --------------------------------
> > >  4 files changed, 262 insertions(+), 347 deletions(-)
> > >  create mode 100644 arch/x86/kernel/module.c
> > >  delete mode 100644 arch/x86/kernel/module_32.c
> > >  delete mode 100644 arch/x86/kernel/module_64.c
> > 
> > Sigh. We went through this before.
> > 
> > First make module_32 and module_64 the same if necessary in 
> > several steps. The last step is to rename one of the files to 
> > module.c and remove the other one.
> > 
> > This cobble all together approach is hard to review and error 
> > prone.
> 
> Correct. There are countless examples of properly structured and 
> well executed unifications in the arch/x86 tree.
> 
> The most recent one has been done by Gustavo F. Padovan - and this 
> was one of this first complex contributions to Linux:
> 
>  c577b09: x86, fixmap: unify fixmap.h
>  c78f322: x86, fixmap: prepare fixmap_32.h for unification
>  e365bcd: x86, fixmap: prepare fixmap_64.h for unification
>  5f403fa: x86, fixmap: add CONFIG_EFI
>  2ae38da: x86, fixmap: add CONFIG_X86_{LOCAL,IO}_APIC
>  fd862dd: x86, fixmap: define reserve_top_address for x86_64
>  ab93e3c: x86, fixmap: define FIXADDR_BOOT_* and redefine FIX_ADDR_SIZE
>  d09375a: x86, fixmap: rename __FIXADDR_SIZE and __FIXADDR_BOOT_SIZE
> 
> Please use this as a template - all-in-one patches for unifications 
> are not reviewable, not testable and not acceptable.
> 

OK, pull request withdrawn.

Thanks,

--
JSR

