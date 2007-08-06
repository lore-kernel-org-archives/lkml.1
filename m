Return-Path: <linux-kernel-owner+w=401wt.eu-S1762999AbXHFHcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762999AbXHFHcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 03:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759544AbXHFHcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 03:32:13 -0400
Received: from rzcomm12.rz.tu-bs.de ([134.169.9.59]:56930 "EHLO
	rzcomm12.rz.tu-bs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761765AbXHFHcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 03:32:11 -0400
Message-ID: <46B6CE6B.7010808@l4x.org>
Date: Mon, 06 Aug 2007 09:31:55 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Thunderbird 2.0.0.6pre (Windows/20070729)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: michal.k.k.piotrowski@gmail.com, wli@holomorphy.com, chris@zankel.net,
       rth@twiddle.net
Subject: 2.6.23-rc2 cross compile regressions (alpha,sparc,xtensa)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sparc/defconfig:
  CC      init/main.o
In file included from include/linux/proc_fs.h:5,
                 from init/main.c:14:
include/linux/fs.h:848: warning: `struct flock' declared inside parameter list
include/linux/fs.h:848: warning: its scope is only this definition or declaration, which is probably not what you want
include/linux/fs.h:850: warning: `struct flock' declared inside parameter list
include/linux/fs.h:853: warning: `struct flock64' declared inside parameter list
include/linux/fs.h:855: warning: `struct flock64' declared inside parameter list
init/main.c: In function `init_post':
init/main.c:782: error: `O_RDWR' undeclared (first use in this function)
init/main.c:782: error: (Each undeclared identifier is reported only once
init/main.c:782: error: for each function it appears in.)
make[2]: *** [init/main.o] Error 1
make[1]: *** [init] Error 2
make: *** [_all] Error 2

xtensa/defconfig:
  CC      arch/xtensa/kernel/process.o
arch/xtensa/kernel/process.c:50: error: `INR_OPEN' undeclared here (not in a function)
arch/xtensa/kernel/process.c:50: error: initializer element is not constant
arch/xtensa/kernel/process.c:50: error: (near initialization for `init_signals.rlim[7].rlim_cur')
arch/xtensa/kernel/process.c:50: error: `INR_OPEN' undeclared here (not in a function)
arch/xtensa/kernel/process.c:50: error: initializer element is not constant
arch/xtensa/kernel/process.c:50: error: (near initialization for `init_signals.rlim[7].rlim_max')
arch/xtensa/kernel/process.c:50: error: initializer element is not constant
arch/xtensa/kernel/process.c:50: error: (near initialization for `init_signals.rlim[7]')
arch/xtensa/kernel/process.c:50: error: initializer element is not constant
arch/xtensa/kernel/process.c:50: error: (near initialization for `init_signals.rlim[8]')
arch/xtensa/kernel/process.c:50: error: initializer element is not constant
arch/xtensa/kernel/process.c:50: error: (near initialization for `init_signals.rlim[9]')
arch/xtensa/kernel/process.c:50: error: initializer element is not constant
arch/xtensa/kernel/process.c:50: error: (near initialization for `init_signals.rlim[10]')
arch/xtensa/kernel/process.c:50: error: initializer element is not constant
arch/xtensa/kernel/process.c:50: error: (near initialization for `init_signals.rlim[11]')
arch/xtensa/kernel/process.c:50: error: initializer element is not constant
arch/xtensa/kernel/process.c:50: error: (near initialization for `init_signals.rlim[12]')
arch/xtensa/kernel/process.c:50: error: initializer element is not constant
arch/xtensa/kernel/process.c:50: error: (near initialization for `init_signals.rlim[13]')
arch/xtensa/kernel/process.c:50: error: initializer element is not constant
arch/xtensa/kernel/process.c:50: error: (near initialization for `init_signals.rlim[14]')
arch/xtensa/kernel/process.c:50: error: initializer element is not constant
arch/xtensa/kernel/process.c:50: error: (near initialization for `init_signals.rlim')
arch/xtensa/kernel/process.c:50: error: initializer element is not constant
arch/xtensa/kernel/process.c:50: error: (near initialization for `init_signals.<anonymous>')
arch/xtensa/kernel/process.c: In function `xtensa_execve':
arch/xtensa/kernel/process.c:449: error: implicit declaration of function `getname'
arch/xtensa/kernel/process.c:449: warning: assignment makes pointer from integer without a cast
arch/xtensa/kernel/process.c:460: error: implicit declaration of function `putname'
make[2]: *** [arch/xtensa/kernel/process.o] Error 1
make[1]: *** [arch/xtensa/kernel] Error 2
make: *** [_all] Error 2

alpha/defconfig:
  LD      .tmp_vmlinux1
arch/alpha/kernel/built-in.o(.text+0xaaa8): In function `pdev_save_srm_config':
include/linux/slub_def.h:154: undefined reference to `__kmalloc_size_too_large'
arch/alpha/kernel/built-in.o(.text+0xaaac):include/linux/slub_def.h:154: undefined reference to `__kmalloc_size_too_large'
arch/alpha/kernel/built-in.o(.text+0xd0a8): In function `module_frob_arch_sections':
include/linux/slub_def.h:154: undefined reference to `__kmalloc_size_too_large'
arch/alpha/kernel/built-in.o(.text+0xd0ac):include/linux/slub_def.h:154: undefined reference to `__kmalloc_size_too_large'
arch/alpha/kernel/built-in.o(.text+0x19388): In function `srmcons_get_private_struct':
include/linux/slub_def.h:154: undefined reference to `__kmalloc_size_too_large'
arch/alpha/kernel/built-in.o(.text+0x1938c):include/linux/slub_def.h:154: more undefined references to `__kmalloc_size_too_large' follow
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [_all] Error 2

With patch: ia64/defconfig.
Not compiling: blackfin,cris,frv,h8300,v850

Jan
