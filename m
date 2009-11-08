Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbZKHR36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbZKHR36 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 12:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbZKHR35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 12:29:57 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:49301 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbZKHR34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 12:29:56 -0500
Date: Sun, 8 Nov 2009 22:59:53 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [GIT PULL v5] hw-breakpoints: Rewrite on top of perf events v5
Message-ID: <20091108172953.GA4465@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1257474542-6648-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257474542-6648-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 06, 2009 at 03:28:55AM +0100, Frederic Weisbecker wrote:

<snipped>

>  arch/Kconfig                         |    3 +
>  arch/x86/include/asm/Kbuild          |    1 +
>  arch/x86/include/asm/debugreg.h      |   11 +-
>  arch/x86/include/asm/hw_breakpoint.h |   58 +++--
>  arch/x86/include/asm/processor.h     |   12 +-
>  arch/x86/kernel/hw_breakpoint.c      |  391 ++++++++++++++--------
>  arch/x86/kernel/process.c            |    9 +-
>  arch/x86/kernel/process_32.c         |   26 +--
>  arch/x86/kernel/process_64.c         |   26 +--
>  arch/x86/kernel/ptrace.c             |  182 +++++++----
>  arch/x86/kernel/smpboot.c            |    3 -
>  arch/x86/kvm/x86.c                   |   18 +-
>  arch/x86/power/cpu.c                 |    6 -
>  include/asm-generic/hw_breakpoint.h  |  139 --------
>  include/linux/hw_breakpoint.h        |  131 ++++++++
>  include/linux/perf_event.h           |   37 ++-
>  kernel/exit.c                        |    5 +
>  kernel/hw_breakpoint.c               |  602 +++++++++++++++++++++-------------
>  kernel/perf_event.c                  |  136 ++++++++-
>  kernel/trace/trace.h                 |    1 -
>  kernel/trace/trace_entries.h         |    6 +-
>  kernel/trace/trace_ksym.c            |  126 ++++----
>  kernel/trace/trace_selftest.c        |    4 +-
>  23 files changed, 1194 insertions(+), 739 deletions(-)

Please make changes to samples/hw_breakpoint/data_breakpoint.c
simultaneously....it breaks the build if CONFIG_SAMPLE_HW_BREAKPOINT is
selected.

Thanks,
K.Prasad

