Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbYDZGKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbYDZGKX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 02:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYDZGKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 02:10:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497AbYDZGKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 02:10:05 -0400
Date: Fri, 25 Apr 2008 23:09:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, penberg@cs.helsinki.fi, tglx@linutronix.de,
       hpa@zytor.com
Subject: Re: [git pull] kmemcheck
Message-Id: <20080425230934.c54a07a0.akpm@linux-foundation.org>
In-Reply-To: <20080424210605.GA26672@elte.hu>
References: <20080424210605.GA26672@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 24 Apr 2008 23:06:05 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>  Documentation/kmemcheck.txt    |  101 +++++
>  arch/x86/Kconfig.debug         |   64 +++
>  arch/x86/kernel/Makefile       |    2 +
>  arch/x86/kernel/cpu/common.c   |    7 +
>  arch/x86/kernel/entry_32.S     |    8 +-
>  arch/x86/kernel/entry_64.S     |    4 +-
>  arch/x86/kernel/kmemcheck.c    |  924 ++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/process.c      |    2 +-
>  arch/x86/kernel/process_32.c   |    4 +-
>  arch/x86/kernel/process_64.c   |   12 +-
>  arch/x86/kernel/traps_32.c     |   18 +-
>  arch/x86/kernel/traps_64.c     |   21 +-
>  arch/x86/mm/fault.c            |   25 +-
>  arch/x86/mm/init_32.c          |    2 -
>  include/asm-x86/kdebug.h       |    3 +-
>  include/asm-x86/kmemcheck.h    |   30 ++
>  include/asm-x86/pgtable.h      |    4 +-
>  include/asm-x86/pgtable_32.h   |    6 +
>  include/asm-x86/string_32.h    |    8 +
>  include/asm-x86/string_64.h    |    1 +
>  include/linux/gfp.h            |    3 +-
>  include/linux/kmemcheck.h      |   29 ++
>  include/linux/slab.h           |    7 +
>  include/linux/slub_kmemcheck.h |   21 +
>  init/main.c                    |    2 +
>  kernel/fork.c                  |   15 +-
>  kernel/sysctl.c                |   12 +
>  mm/Makefile                    |    3 +
>  mm/slub.c                      |   25 +-
>  mm/slub_kmemcheck.c            |  100 +++++

Can we have a MAINTAINERS update please?
