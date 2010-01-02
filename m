Return-Path: <linux-kernel-owner+w=401wt.eu-S1751955Ab0ABVk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab0ABVk5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 16:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721Ab0ABVkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 16:40:55 -0500
Received: from cantor.suse.de ([195.135.220.2]:47324 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab0ABVkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 16:40:55 -0500
Date: Sat, 2 Jan 2010 22:40:48 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Jiri Slaby <jirislaby@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Neil Horman <nhorman@tuxdriver.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PULL] pull request for writable limits for 2.6.33-rc0
In-Reply-To: <4B1FF9A1.2040305@gmail.com>
Message-ID: <alpine.LRH.2.00.1001022239060.15694@twin.jikos.cz>
References: <4B1D32D1.4090404@gmail.com> <4B1FF9A1.2040305@gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009, Jiri Slaby wrote:

> ---
> The following changes since commit 2588465badb648a50cd19623f0dd0063c90d4e31:
>   Linus Torvalds (1):
>         Merge branch 'bkl-arch-for-linus' of
> git://git.kernel.org/.../tip/linux-2.6-tip
> 
> are available in the git repository at:
> 
>   git://decibel.fi.muni.cz/~xslaby/linux writable_limits
> 
> Jiri Slaby (25):
>       SECURITY: selinux, fix update_rlimit_cpu parameter
>       SECURITY: add task_struct to setrlimit
>       core: add task_struct to update_rlimit_cpu
>       core: split sys_setrlimit
>       core: allow setrlimit to non-current tasks
>       core: optimize setrlimit for current task
>       FS: proc, switch limits reading to fops
>       FS: proc, make limits writable
>       core: do security check under task_lock
>       core: rename setrlimit to do_setrlimit
>       resource: move kernel functions inside __KERNEL__
>       core: posix-cpu-timers, cleanup rlimits usage
>       resource: add helpers for fetching rlimits
>       IA64: use helpers for rlimits
>       PPC: use helpers for rlimits
>       S390: use helpers for rlimits
>       SPARC: use helpers for rlimits
>       X86: use helpers for rlimits
>       FS: use helpers for rlimits
>       MM: use helpers for rlimits
>       core: use helpers for rlimits
>       misc: use helpers for rlimits
>       core: implement getprlimit and setprlimit syscalls
>       COMPAT: add get/put_compat_rlimit
>       x86: add ia32 compat prlimit syscalls
> 
> Neil Horman (1):
>       unistd: add __NR_[get|set]prlimit syscall numbers
> 
> Oleg Nesterov (1):
>       sys_setrlimit: make sure ->rlim_max never grows

Hmm, so this seems to have missed thw 2.6.33 merge window, being dropped 
in a silent way.

Linus, is there any reason you have not pulled this for .33 (I can't see 
any objections from previous reviews), or was this just forgotten?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

