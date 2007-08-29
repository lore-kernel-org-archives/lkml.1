Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbXH2SFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbXH2SFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 14:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756267AbXH2SFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 14:05:04 -0400
Received: from mail.trixing.net ([87.230.125.58]:59892 "EHLO mail.trixing.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbXH2SFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 14:05:01 -0400
Message-ID: <46D5B544.4030708@l4x.org>
Date: Wed, 29 Aug 2007 20:04:52 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070329 Thunderbird/1.5.0.10 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christian Zankel <chris@zankel.net>, linux-alpha@vger.kernel.org
References: <46D5902C.1040905@googlemail.com>
In-Reply-To: <46D5902C.1040905@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.195
X-SA-Exim-Mail-From: jdi@l4x.org
Subject: Re: [1/4] 2.6.23-rc4: known regressions
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on mail.trixing.net)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Subject         : 2.6.23-rc2 cross compile regressions (alpha,xtensa)
> References      : http://lkml.org/lkml/2007/8/6/43 
> Last known good : alpha: 2.6.22-git8 xtensa: 2.6.22-git6
> Submitter       : Jan Dittmer <jdi@l4x.org>
> Caused-By       : ?
> Handled-By      : xtensa: Christian Zankel <chris@zankel.net>
> Status          : unknown

Status: Unfixed

alpha:  http://l4x.org/k/?d=33700
  CC      init/version.o
  LD      init/built-in.o
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


xtensa: http://l4x.org/k/?d=33728
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


Jan

