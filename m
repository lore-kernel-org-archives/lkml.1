Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbZG0HIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbZG0HIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 03:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbZG0HIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 03:08:51 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:38644 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbZG0HIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 03:08:50 -0400
Message-ID: <4A6D527E.3030501@monstr.eu>
Date: Mon, 27 Jul 2009 09:08:46 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] arch/microblaze fixes for 2.6.31-rc5
References: <4A6D4D9F.9080402@monstr.eu>
In-Reply-To: <4A6D4D9F.9080402@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I forget to remove one my commit (microblaze: Export memcpy, memmove for ASM optimized code)
I updated fixes-for-linus branch.
Please pull these changes.

Sorry for confusion.
Thanks,
Michal



The following changes since commit 4be3bd7849165e7efa6b0b35a23d6a3598d97465:
  Linus Torvalds (1):
        Linux 2.6.31-rc4

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git fixes-for-linus

Arnd Bergmann (1):
      microblaze: remove sys_ipc

Huang Weiyi (1):
      microblaze: remove duplicated #include

John Williams (2):
      microblaze: Final support for statically linked DTB
      microblaze: Get module loading working

Michal Simek (11):
      microblaze: Define tlb_flush macro
      microblaze: Add messages about FDT blob
      microblaze: Not to clear r7 after copying DTB to kernel
      microblaze: Clear print messages for DTB passing via r7
      microblaze: Fix put_user macro for 64bits arguments
      microblaze: Add _PAGE_FILE macros to pgtable.h
      microblaze: Fix do_page_fault for no context
      microblaze: Detect new Microblaze 7.20 versions
      microblaze: Support unaligned address for put/get_user macros
      microblaze: Add support for R_MICROBLAZE_64_NONE
      microblaze: Typo fix for cpu param inconsistency

Sam Ravnborg (1):
      microblaze: Makefile cleanup

 arch/microblaze/Makefile                      |   35 ++++----
 arch/microblaze/include/asm/io.h              |    1 -
 arch/microblaze/include/asm/pgtable.h         |    6 +-
 arch/microblaze/include/asm/prom.h            |   23 +++---
 arch/microblaze/include/asm/tlb.h             |    2 +-
 arch/microblaze/include/asm/uaccess.h         |    2 +-
 arch/microblaze/kernel/Makefile               |    2 +-
 arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c |    2 +-
 arch/microblaze/kernel/cpu/cpuinfo-static.c   |    2 +-
 arch/microblaze/kernel/cpu/cpuinfo.c          |    2 +
 arch/microblaze/kernel/head.S                 |   17 +++-
 arch/microblaze/kernel/hw_exception_handler.S |  109 +++++++++++--------------
 arch/microblaze/kernel/module.c               |   19 +++-
 arch/microblaze/kernel/setup.c                |    8 ++-
 arch/microblaze/kernel/sys_microblaze.c       |   99 ----------------------
 arch/microblaze/kernel/syscall_table.S        |    2 +-
 arch/microblaze/mm/fault.c                    |   15 +---
 17 files changed, 126 insertions(+), 220 deletions(-)



Michal Simek wrote:
> Hi Linus,
> 
> please pull the following changes.
> 
> Thanks,
> Michal
> 
> 
> The following changes since commit 4be3bd7849165e7efa6b0b35a23d6a3598d97465:
>   Linus Torvalds (1):
>         Linux 2.6.31-rc4
> 
> are available in the git repository at:
> 
>   git://git.monstr.eu/linux-2.6-microblaze.git fixes-for-linus
> 
> Arnd Bergmann (1):
>       microblaze: remove sys_ipc
> 
> Huang Weiyi (1):
>       microblaze: remove duplicated #include
> 
> John Williams (2):
>       microblaze: Final support for statically linked DTB
>       microblaze: Get module loading working
> 
> Michal Simek (12):
>       microblaze: Define tlb_flush macro
>       microblaze: Add messages about FDT blob
>       microblaze: Not to clear r7 after copying DTB to kernel
>       microblaze: Clear print messages for DTB passing via r7
>       microblaze: Fix put_user macro for 64bits arguments
>       microblaze: Add _PAGE_FILE macros to pgtable.h
>       microblaze: Fix do_page_fault for no context
>       microblaze: Detect new Microblaze 7.20 versions
>       microblaze: Export memcpy, memmove for ASM optimized code
>       microblaze: Support unaligned address for put/get_user macros
>       microblaze: Add support for R_MICROBLAZE_64_NONE
>       microblaze: Typo fix for cpu param inconsistency
> 
> Sam Ravnborg (1):
>       microblaze: Makefile cleanup
> 
>  arch/microblaze/Makefile                      |   35 ++++----
>  arch/microblaze/include/asm/io.h              |    1 -
>  arch/microblaze/include/asm/pgtable.h         |    6 +-
>  arch/microblaze/include/asm/prom.h            |   23 +++---
>  arch/microblaze/include/asm/tlb.h             |    2 +-
>  arch/microblaze/include/asm/uaccess.h         |    2 +-
>  arch/microblaze/kernel/Makefile               |    2 +-
>  arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c |    2 +-
>  arch/microblaze/kernel/cpu/cpuinfo-static.c   |    2 +-
>  arch/microblaze/kernel/cpu/cpuinfo.c          |    2 +
>  arch/microblaze/kernel/head.S                 |   17 +++-
>  arch/microblaze/kernel/hw_exception_handler.S |  109
> +++++++++++--------------
>  arch/microblaze/kernel/microblaze_ksyms.c     |    7 ++
>  arch/microblaze/kernel/module.c               |   19 +++-
>  arch/microblaze/kernel/setup.c                |    8 ++-
>  arch/microblaze/kernel/sys_microblaze.c       |   99 ----------------------
>  arch/microblaze/kernel/syscall_table.S        |    2 +-
>  arch/microblaze/mm/fault.c                    |   15 +---
>  18 files changed, 133 insertions(+), 220 deletions(-)
> 
> 
> 

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
