Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbZI1UTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbZI1UTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 16:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZI1UTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 16:19:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:51455 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753170AbZI1UTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 16:19:19 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/80mYXMRb8Jo3awBnt2YUUGb6pJDUmMrNE5VFEuH
	A25UFUKWy/zciO
Message-ID: <4AC11A49.7080009@gmx.de>
Date: Mon, 28 Sep 2009 22:19:21 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: kyle@mcmartin.ca
CC: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: What's in parisc-2.6.git
References: <20090928162522.GA22368@hera.kernel.org>
In-Reply-To: <20090928162522.GA22368@hera.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2009 06:25 PM, Kyle McMartin wrote:
> Rebased on top of v2.6.32-rc1, fixed tracehook. Seems to build alright
> on my pa8800 in a few different configs. Is anything missing?


I did tested it on my boxes as well, and it seems OK.
Nothing important missing.
Thanks Kyle!

Helge

> regards, Kyle
>
> The following changes since commit 17d857be649a21ca90008c6dc425d849fa83db5c:
>    Linus Torvalds (1):
>          Linux 2.6.32-rc1
>
> are available in the git repository at:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/kyle/parisc-2.6.git parisc
>
> Christoph Hellwig (1):
>        parisc: convert to asm-generic/hardirq.h
>
> Helge Deller (2):
>        parisc: rename parisc's vmalloc_start to parisc_vmalloc_start
>        parisc: Fix linker script breakage.
>
> James Bottomley (1):
>        parisc: add me to Maintainers
>
> Jaswinder Singh Rajput (1):
>        parisc: includecheck fix: signal.c
>
> Julia Lawall (1):
>        parisc: correct use of SHF_ALLOC
>
> Kyle McMartin (7):
>        parisc: tracehook_report_syscall
>        parisc: tracehook_signal_handler
>        parisc: add missing TI_TASK macro in syscall.S
>        parisc: split syscall_trace into two halves
>        parisc: stop using task->ptrace for {single,block}step flags
>        parisc: add skeleton syscall.h
>        parisc: HAVE_ARCH_TRACEHOOK
>
> Tim Abbott (1):
>        parisc: Make THREAD_SIZE available to assembly files and linker scripts.
>
>   MAINTAINERS                           |    1 +
>   arch/parisc/Kconfig                   |    1 +
>   arch/parisc/include/asm/fixmap.h      |    4 +-
>   arch/parisc/include/asm/hardirq.h     |   20 +---------------
>   arch/parisc/include/asm/ptrace.h      |    5 +++-
>   arch/parisc/include/asm/syscall.h     |   40 +++++++++++++++++++++++++++++++
>   arch/parisc/include/asm/thread_info.h |   14 +++++++----
>   arch/parisc/kernel/asm-offsets.c      |    4 +-
>   arch/parisc/kernel/entry.S            |   21 ++++++++--------
>   arch/parisc/kernel/irq.c              |    5 ----
>   arch/parisc/kernel/module.c           |    2 +-
>   arch/parisc/kernel/ptrace.c           |   42 ++++++++++++++++----------------
>   arch/parisc/kernel/signal.c           |    5 +++-
>   arch/parisc/kernel/syscall.S          |   22 +++++++++++------
>   arch/parisc/kernel/vmlinux.lds.S      |   10 ++++++++
>   arch/parisc/mm/init.c                 |   11 ++++----
>   16 files changed, 127 insertions(+), 80 deletions(-)
>   create mode 100644 arch/parisc/include/asm/syscall.h
>

