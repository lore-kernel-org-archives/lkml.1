Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbYBIX0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbYBIX0u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 18:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbYBIX0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 18:26:40 -0500
Received: from www.tglx.de ([62.245.132.106]:42449 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250AbYBIX0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 18:26:39 -0500
Date: Sun, 10 Feb 2008 00:24:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 updates
Message-ID: <alpine.LFD.1.00.0802092246390.3145@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the pending x86 updates from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git master

The update contains:

    - a couple of bugfixes
    - CPA and DEBUG_PAGEALLOC improvements
    - x86 power management consolidation 
    - GEODE updates
    - 32bit boot time page table construction rework
    - sparse and compile warning fixes
    - trivial cleanups

There are two patches out of x86 scope as well:

    - lguest bugfix: x86 broke it, fix is obviously correct and Rusty
      is away

    - randomization docs: resulted out of a x86 randomization
      discussion

Thanks,

	tglx

----

Ahmed S. Darwish (1):
      lguest: accept guest _PAGE_PWT page table entries

Andres Salomon (5):
      x86: GEODE: MFGPT: Minor cleanups
      x86: GEODE: MFGPT: drop module owner usage from MFGPT API
      x86: GEODE: MFGPT: replace 'flags' field with 'avail' bit
      x86: GEODE: MFGPT: make mfgpt_timer_setup available outside of mfgpt_32.c
      x86: GEODE: MFGPT: fix a potential race when disabling a timer

Arnd Hannemann (1):
      x86: GEODE: MFGPT: fix typo in printk in mfgpt_timer_setup

Denys Vlasenko (1):
      x86: trivial printk optimizations

Harvey Harrison (6):
      x86: fix sparse warning in xen/time.c
      x86: sparse warning in therm_throt.c
      x86: sparse warnings in pageattr.c
      x86: fix sparse warning in topology.c
      x86: fix sparse warnings in acpi/bus.c
      x86, core: remove CONFIG_FORCED_INLINING

Ian Campbell (2):
      x86: construct 32-bit boot time page tables in native format.
      x86: fix early_ioremap pagetable ops

Ingo Molnar (2):
      x86: fixup more paravirt fallout
      brk: help text typo fix

Jiri Kosina (1):
      brk: document randomize_va_space and CONFIG_COMPAT_BRK (was Re:

Jordan Crouse (2):
      x86: GEODE: MFGPT: Use "just-in-time" detection for the MFGPT timers
      x86: GEODE: make sure the right MFGPT timer fired the timer tick

Rafael J. Wysocki (4):
      x86 PM: move 64-bit hibernation files to arch/x86/power
      x86 PM: rename 32-bit files in arch/x86/power
      x86 PM: consolidate suspend and hibernation code
      x86 PM: update stale comments

Thomas Gleixner (6):
      x86: avoid unused variable warning in mm/init_64.c
      x86: DEBUG_PAGEALLOC: enable after mem_init()
      x86: introduce page pool in cpa
      x86: cpa, use page pool
      x86: cpa, enable CONFIG_DEBUG_PAGEALLOC on 64-bit
      x86: cpa, strict range check in try_preserve_large_page()

Willy Tarreau (1):
      x86: GEODE fix MFGPT input clock value

