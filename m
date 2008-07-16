Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbYGPNzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbYGPNzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 09:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755119AbYGPNz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 09:55:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58184 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548AbYGPNz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 09:55:28 -0400
Date: Wed, 16 Jul 2008 15:54:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] x86 changes for v2.6.27
Message-ID: <20080716135453.GA27148@elte.hu>
References: <20080714135034.GA7013@elte.hu> <20080715025149.GA6137@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715025149.GA6137@redhat.com>
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

* Dave Jones <davej@redhat.com> wrote:

> On Mon, Jul 14, 2008 at 03:50:35PM +0200, Ingo Molnar wrote:
>  > Linus,
>  > 
>  > Please pull the latest x86 git tree from:
>  > 
>  >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/for-linus
>  > 
>  > this is our first merge window since we migrated over to a pure Git 
>  > based patch management setup and integrated x86.git into the -tip tree. 
>  > Going from Quilt to Git was quite hard for this 
>  > 1000-patches-per-kernel-cycle tree, so please bear with us :-)
>  > 
>  > 42 individual x86 topic trees arose in the past development cycle:
>  > 
>  >  x86/amd-iommu, x86/apic, x86/apm, x86/bitops, x86/build, x86/cleanups,
>  >  x86/core, x86/cpa, x86/cpu, x86/debug, x86/defconfig, x86/delay,
>  >  x86/fixmap, x86/gart, x86/generalize-visws, x86/i8259, x86/idle, x86/intel,
>  >  x86/irq, x86/irqstats, x86/kconfig, x86/ldt, x86/mce, x86/memtest, x86/mmio,
>  >  x86/mpparse, x86/nmi, x86/numa, x86/numa-fixes, x86/oprofile, x86/pat,
>  >  x86/ptemask, x86/ptrace, x86/resumetrace, x86/setup, x86/threadinfo,
>  >  x86/timers, x86/unify-lib, x86/unify-pci, x86/uv, x86/vdso, x86/xen.
>  > 
>  > .. carrying a total of 820 (non-git-merge) commits from 70 authors.
> 
> Wow.
> 
> 6924d1ab8b7bbe5ab416713f5701b3316b2df85b is a work of art.
> Is it ascii-art tetris? a magic eye picture? you decide!
> 
> It looks even more spectacular in gitk.

heh, thanks :)

Being able to shuffle around independent topics and only sending those 
which were ready was the single biggest advantage that quilt had for us. 
So we tried hard to keep the same workflow property under git as well. 
We were sceptical in the beginning due to git's fundamental append-only 
nature but after a ton of scripting by Thomas and me it turned out to be 
doable under git as well.

In hindsight going to a pure git workflow worked out pretty well i think 
and Linus was right when he suggested that we'd be happier with a pure 
git workflow. We are now roughly back to the same speed and reliability 
of processing incoming patches as we were under quilt with the 
monolothic x86 and sched-devel trees and the end result is (much) more 
structured so it's a marked improvement.

... so we've got all the advantages of a quilt workflow, and all the 
advantages of git as well, combined. Scripted per topic progress reports 
like the one below were unthinkable under quilt. So there's no looking 
back :-)

	Ingo

-------------------------------------------------------------------->
earth4:~/tip> tip-pending

topic                                   #commits
------------------------------------------------
acpi-for-len                            :      2
core/futex-64bit                        :      1
core/generic-dma-coherent               :      1
core/kill-the-BKL                       :     18
core/misc                               :      2
core/percpu                             :      3
core/percpu-zerobased                   :      4
core/softlockup                         :      8
core/warn-API                           :     15
cpus4096                                :     13
kmemcheck                               :     20
out-of-tree                             :     16
pci-for-jesse                           :      1
safe-poison-pointers                    :      1
stackprotector                          :     18
timers/hpet                             :      2
tracing/immediates                      :     26
tracing/markers                         :      7
tracing/nmisafe                         :      5
tracing/sched_markers                   :      1
tracing/textedit                        :      5
x86/amd-iommu                           :     16
x86/audit-speedup                       :     66
x86/cleanups                            :      2
x86/gart                                :      3
x86/header-guards                       :      2
x86/mm-debug                            :      2
x86/paravirt-spinlocks                  :     70
x86/pci-ioapic-boot-irq-quirks          :      9
x86/pebs                                :      3
x86/unify-mce                           :      9
x86/unify-pci                           :      4
x86/x2apic                              :     35
xen-64bit                               :     63
---------------------
auto-core-next                          :     15
auto-cpus4096-next                      :     13
auto-kmemcheck-next                     :     20
auto-safe-poison-pointers-next          :      1
auto-stackprotector-next                :     18
auto-timers-next                        :      3
auto-x86-next                           :    104
---------------------
auto-latest                             :    215
---------------------
total topics:     129
pending topics:    34
pending commits:  453
unique commits:   376
