Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbZLIGMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbZLIGMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 01:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbZLIGMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 01:12:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45144 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106AbZLIGMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 01:12:08 -0500
Date: Wed, 9 Dec 2009 07:11:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Carsten Emde <Carsten.Emde@osadl.org>,
       Olof Johansson <olof@lixom.net>, hpa@zytor.com, tglx@linutronix.de
Subject: Re: [PATCH][GIT PULL][v2.6.33] tracing: Remove comparing of NULL to
 va_list in trace_array_vprintk()
Message-ID: <20091209061148.GA14010@elte.hu>
References: <4B01AE5D.1010801@osadl.org>
 <tip-c13d2f7c3231e873f30db92b96c8caa48f100f33@git.kernel.org>
 <20091206051352.GA4628@lixom.net>
 <4B1BAB74.104@osadl.org>
 <1260332397.2146.38.camel@gandalf.stny.rr.com>
 <20091209055602.GB2512@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091209055602.GB2512@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-tip testing found that the Alpha defconfig fails to build. (error log 
attached below)

To fix this bug i have unpulled this commit for now:

 efcf61a: tracing: Remove comparing of NULL to va_list in trace_array_vprintk()

Thanks,

	Ingo

---------------->
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/init/noinitramfs.c:23:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/init/main.c:16:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
cc1: warnings being treated as errors
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/arch/alpha/kernel/osf_sys.c:20:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: error: no return statement in function returning non-void
cc1: warnings being treated as errors
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/arch/alpha/kernel/alpha_ksyms.c:15:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: error: no return statement in function returning non-void
make[2]: *** [arch/alpha/kernel/alpha_ksyms.o] Error 1
make[2]: *** Waiting for unfinished jobs....
cc1: warnings being treated as errors
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/arch/alpha/kernel/signal.c:22:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: error: no return statement in function returning non-void
make[2]: *** [arch/alpha/kernel/osf_sys.o] Error 1
make[2]: *** [arch/alpha/kernel/signal.o] Error 1
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/init/do_mounts.h:4,
                 from /home/mingo/tip/init/do_mounts.c:23:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/kernel/exec_domain.c:18:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/kernel/sched.c:62:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/kernel/fork.c:38:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/kernel/printk.c:34:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/kernel/itimer.c:11:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/mm/fadvise.c:19:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
make[1]: *** [arch/alpha/kernel] Error 2
make[1]: *** Waiting for unfinished jobs....
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/kernel/exit.c:36:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/kernel/capability.c:15:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/mm/filemap.c:32:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/kernel/sysctl.c:45:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/kernel/ptrace.c:23:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/kernel/timer.c:36:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/mm/page-writeback.c:34:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/kernel/signal.c:21:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/kernel/kmod.c:23:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/open.c:28:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/kernel/sysctl_binary.c:7:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/read_write.c:16:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/kernel/pid.c:38:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/super.c:33:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/stat.c:15:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/kernel/posix-timers.c:45:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/fcntl.c:7:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/exec.c:49:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/pipe.c:20:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/ioctl.c:7:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/namei.c:28:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/select.c:19:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/readdir.c:17:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/mm/fremap.c:17:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/kernel/hrtimer.c:39:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/mm/madvise.c:10:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/mm/mincore.c:14:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/dcache.c:17:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/mm/mmap.c:16:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/mm/mlock.c:15:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/mm/mremap.c:21:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/mm/mprotect.c:21:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/mm/msync.c:14:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/namespace.c:11:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/kernel/groups.c:8:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/filesystems.c:9:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/kernel/futex.c:56:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
/home/mingo/tip/kernel/irq/handle.c:437:3: warning: #warning __do_IRQ is deprecated. Please convert to proper flow handlers
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/xattr.c:17:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/kernel/module.c:21:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/mm/swapfile.c:30:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/splice.c:30:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/sync.c:11:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/utimes.c:10:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/kernel/time.c:35:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/buffer.c:22:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/ioprio.c:26:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/notify/inotify/inotify_user.c:38:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/eventpoll.c:28:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/signalfd.c:30:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/timerfd.c:23:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/eventfd.c:17:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/locks.c:126:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/aio.c:17:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:71,
                 from /home/mingo/tip/fs/nfsctl.c:18:
/home/mingo/tip/include/linux/trace_seq.h: In function 'trace_print_seq':
/home/mingo/tip/include/linux/trace_seq.h:62: warning: no return statement in function returning non-void
make[1]: *** wait: No child processes.  Stop.
make: *** [sub-make] Error 2

