Return-Path: <linux-kernel-owner+w=401wt.eu-S1760691AbYENJyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbYENJyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 05:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbYENJy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 05:54:26 -0400
Received: from gw.goop.org ([64.81.55.164]:33381 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbYENJyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 05:54:25 -0400
Message-ID: <482AB6C5.4060604@goop.org>
Date: Wed, 14 May 2008 10:54:13 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: x86-64 build problem with tip
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting this when I build for x86-64 with

jeremy@cosworth:~/hg/xen/paravirt/linux-x86_64$ gcc -v
Reading specs from /usr/lib/gcc/x86_64-linux/3.4.4/specs
Configured with: ../src/configure -v --enable-languages=c,c++,java,f77,pascal,objc,ada,treelang --prefix=/usr --libexecdir=/usr/lib --with-gxx-include-dir=/usr/include/c++/3.4 --enable-shared --with-system-zlib --enable-nls --without-included-gettext --program-suffix=-3.4 --enable-__cxa_atexit --enable-libstdcxx-allocator=mt --enable-clocale=gnu --enable-libstdcxx-debug --enable-java-gc=boehm --enable-java-awt=gtk --disable-werror x86_64-linux
Thread model: posix
gcc version 3.4.4 20050314 (prerelease) (Debian 3.4.3-13)


  CC      kernel/sched.o
/home/jeremy/hg/xen/paravirt/linux/kernel/sched_trace.h: In function `wait_task_inactive':
/home/jeremy/hg/xen/paravirt/linux/kernel/sched_trace.h:5: warning: asm operand 1 probably doesn't match constraints
/home/jeremy/hg/xen/paravirt/linux/kernel/sched_trace.h:5: error: impossible constraint in `asm'
/home/jeremy/hg/xen/paravirt/linux/kernel/sched_trace.h:5: warning: 'value' might be used uninitialized in this function
/home/jeremy/hg/xen/paravirt/linux/kernel/sched.c: At top level:
/home/jeremy/hg/xen/paravirt/linux/kernel/sched_fair.c:1167: warning: 'wakeup_preempt_entity' defined but not used
make[3]: *** [kernel/sched.o] Error 1


Turning CONFIG_MARKER off avoids the problem.

    J
