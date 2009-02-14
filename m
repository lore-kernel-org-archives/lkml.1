Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbZBNWbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbZBNWbz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbZBNWbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:31:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55372 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbZBNWbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:31:47 -0500
Date: Sat, 14 Feb 2009 23:31:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: L-K <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] pending lockdep patches
Message-ID: <20090214223136.GC5200@elte.hu>
References: <1234629408.4698.40.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234629408.4698.40.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> The following changes since commit 394c22392b6c3aa78825cf7cb0daed5797b64ee1:
>   Ingo Molnar (1):                                                          
>         Merge branch 'linus'                                                
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git lockdep-200902141725
> 
> Johannes Berg (1):
>       timer: implement lockdep deadlock detection
> 
> Nick Piggin (1):
>       lockdep: annotate reclaim context (__GFP_NOFS)
> 
> Peter Zijlstra (22):
>       lockdep: sanitize bit names
>       lockdep: sanitize reclaim bit names
>       lockdep: lockdep_states.h
>       lockdep: simplify mark_held_locks
>       lockdep: simplify mark_lock()
>       lockdep: move state bit definitions around
>       lockdep: generate the state bit definitions
>       lockdep: generate usage strings
>       lockdep: split up mark_lock_irq()
>       lockdep: simplify the mark_lock_irq() helpers
>       lockdep: further simplify mark_lock_irq() helpers
>       lockdep: simplify mark_lock_irq() helpers #3
>       lockdep: merge the _READ mark_lock_irq() helpers
>       lockdep: merge the !_READ mark_lock_irq() helpers
>       lockdep: fully reduce mark_lock_irq()
>       lockdep: remove macro usage from mark_held_locks()
>       lockdep: add comments to mark_lock_irq()
>       lockdep: simplify get_user_chars()
>       lockdep: get_user_chars() redo
>       lockdep: simplify check_prev_add_irq()
>       lockdep: use stringify.h
>       lockstat: warn about disabled lock debugging
> 
>  Documentation/lockdep-design.txt |   30 ++-
>  include/linux/lockdep.h          |   50 +---
>  include/linux/sched.h            |    1 +
>  include/linux/timer.h            |   93 +++++++-
>  kernel/lockdep.c                 |  507 +++++++++++++++++++-------------------
>  kernel/lockdep_internals.h       |   45 ++++-
>  kernel/lockdep_proc.c            |   22 +-
>  kernel/lockdep_states.h          |    9 +
>  kernel/timer.c                   |   68 +++++-
>  mm/page_alloc.c                  |    5 +
>  mm/slab.c                        |    4 +
>  mm/slob.c                        |    2 +
>  mm/slub.c                        |    1 +
>  mm/vmscan.c                      |    3 +
>  14 files changed, 501 insertions(+), 339 deletions(-)
>  create mode 100644 kernel/lockdep_states.h

Pulled into tip:core/locking, thanks a lot Peter!

	Ingo
