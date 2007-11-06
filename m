Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbXKFVF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbXKFVF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbXKFVFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:05:51 -0500
Received: from mail.trixing.net ([87.230.125.58]:40577 "EHLO mail.trixing.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbXKFVFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:05:50 -0500
Message-ID: <4730D713.7060406@l4x.org>
Date: Tue, 06 Nov 2007 22:05:23 +0100
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <472B9479.7040105@l4x.org> <15675.1193753820@redhat.com> <4726337B.1080608@l4x.org> <4725B553.4060502@l4x.org> <4220.1193663179@redhat.com> <15712.1193753924@redhat.com> <27945.1194278666@redhat.com>
In-Reply-To: <27945.1194278666@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.106
X-SA-Exim-Mail-From: jdi@l4x.org
Subject: Re: Working frv toolchain?
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on mail.trixing.net)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Jan Dittmer <jdi@l4x.org> wrote:
> 
>> Hrm, that gets me further, but one of the final stages fail:
> 
> Can you try the attached patch?

Thanks, that fixes the error in question. Now I have only
a couple of scary looking warnings (see below, sorry for
the word-wrap). So it's no toolchain problem then, after all?
Are there any chances to get a patch for frv support against
some upstream gcc 4.x version?

Thanks,

Jan


  LD      kernel/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_set_robust_list' changed 
from 8 in kernel/sys_ni.o to 32 in kernel/futex.o
frv-linux-gnu-ld: Warning: size of symbol `sys_get_robust_list' changed 
from 8 in kernel/sys_ni.o to 252 in kernel/futex.o
frv-linux-gnu-ld: Warning: size of symbol `sys_futex' changed from 8 in 
kernel/sys_ni.o to 476 in kernel/futex.o
frv-linux-gnu-ld: Warning: size of symbol `sys_chown16' changed from 8 
in kernel/sys_ni.o to 56 in kernel/uid16.o
frv-linux-gnu-ld: Warning: size of symbol `sys_lchown16' changed from 8 
in kernel/sys_ni.o to 56 in kernel/uid16.o
frv-linux-gnu-ld: Warning: size of symbol `sys_fchown16' changed from 8 
in kernel/sys_ni.o to 56 in kernel/uid16.o
frv-linux-gnu-ld: Warning: size of symbol `sys_setregid16' changed from 
8 in kernel/sys_ni.o to 56 in kernel/uid16.o
frv-linux-gnu-ld: Warning: size of symbol `sys_setgid16' changed from 8 
in kernel/sys_ni.o to 40 in kernel/uid16.o
frv-linux-gnu-ld: Warning: size of symbol `sys_setreuid16' changed from 
8 in kernel/sys_ni.o to 56 in kernel/uid16.o
frv-linux-gnu-ld: Warning: size of symbol `sys_setuid16' changed from 8 
in kernel/sys_ni.o to 40 in kernel/uid16.o
frv-linux-gnu-ld: Warning: size of symbol `sys_setresuid16' changed from 
8 in kernel/sys_ni.o to 156 in kernel/uid16.o
frv-linux-gnu-ld: Warning: size of symbol `sys_getresuid16' changed from 
8 in kernel/sys_ni.o to 312 in kernel/uid16.o
frv-linux-gnu-ld: Warning: size of symbol `sys_setresgid16' changed from 
8 in kernel/sys_ni.o to 156 in kernel/uid16.o
frv-linux-gnu-ld: Warning: size of symbol `sys_getresgid16' changed from 
8 in kernel/sys_ni.o to 312 in kernel/uid16.o
frv-linux-gnu-ld: Warning: size of symbol `sys_setfsuid16' changed from 
8 in kernel/sys_ni.o to 40 in kernel/uid16.o
frv-linux-gnu-ld: Warning: size of symbol `sys_setfsgid16' changed from 
8 in kernel/sys_ni.o to 40 in kernel/uid16.o
frv-linux-gnu-ld: Warning: size of symbol `sys_getgroups16' changed from 
8 in kernel/sys_ni.o to 368 in kernel/uid16.o
frv-linux-gnu-ld: Warning: size of symbol `sys_setgroups16' changed from 
8 in kernel/sys_ni.o to 452 in kernel/uid16.o
frv-linux-gnu-ld: Warning: size of symbol `sys_getuid16' changed from 8 
in kernel/sys_ni.o to 36 in kernel/uid16.o
frv-linux-gnu-ld: Warning: size of symbol `sys_geteuid16' changed from 8 
in kernel/sys_ni.o to 36 in kernel/uid16.o
frv-linux-gnu-ld: Warning: size of symbol `sys_getgid16' changed from 8 
in kernel/sys_ni.o to 36 in kernel/uid16.o
frv-linux-gnu-ld: Warning: size of symbol `sys_getegid16' changed from 8 
in kernel/sys_ni.o to 36 in kernel/uid16.o
   GEN     .version
   CHK     include/linux/compile.h
   UPD     include/linux/compile.h
   CC      init/version.o
   LD      init/built-in.o
   LD      .tmp_vmlinux1
   KSYM    .tmp_kallsyms1.S
   AS      .tmp_kallsyms1.o
   LD      .tmp_vmlinux2
   KSYM    .tmp_kallsyms2.S
   AS      .tmp_kallsyms2.o
   LD      vmlinux.o
frv-linux-gnu-ld: Warning: size of symbol `sys_munlockall' changed from 
8 in kernel/built-in.o to 72 in mm/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_swapoff' changed from 8 
in kernel/built-in.o to 2568 in mm/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_remap_file_pages' changed 
from 8 in kernel/built-in.o to 1008 in mm/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_munlock' changed from 8 
in kernel/built-in.o to 116 in mm/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_mincore' changed from 8 
in kernel/built-in.o to 1056 in mm/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_msync' changed from 8 in 
kernel/built-in.o to 448 in mm/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_swapon' changed from 8 in 
kernel/built-in.o to 2428 in mm/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_madvise' changed from 8 
in kernel/built-in.o to 1400 in mm/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_mlockall' changed from 8 
in kernel/built-in.o to 196 in mm/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_mprotect' changed from 8 
in kernel/built-in.o to 576 in mm/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_mlock' changed from 8 in 
kernel/built-in.o to 200 in mm/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_mremap' changed from 8 in 
kernel/built-in.o to 132 in mm/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_eventfd' changed from 8 
in kernel/built-in.o to 176 in fs/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_epoll_create' changed 
from 8 in kernel/built-in.o to 252 in fs/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_ioprio_set' changed from 
8 in kernel/built-in.o to 584 in fs/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_epoll_pwait' changed from 
8 in kernel/built-in.o to 356 in fs/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_epoll_ctl' changed from 8 
in kernel/built-in.o to 1424 in fs/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_epoll_wait' changed from 
8 in kernel/built-in.o to 1392 in fs/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_inotify_add_watch' 
changed from 8 in kernel/built-in.o to 496 in fs/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_signalfd' changed from 8 
in kernel/built-in.o to 476 in fs/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_inotify_init' changed 
from 8 in kernel/built-in.o to 524 in fs/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_bdflush' changed from 8 
in kernel/built-in.o to 124 in fs/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_inotify_rm_watch' changed 
from 8 in kernel/built-in.o to 132 in fs/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_ioprio_get' changed from 
8 in kernel/built-in.o to 512 in fs/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_msgget' changed from 8 in 
kernel/built-in.o to 132 in ipc/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_mq_getsetattr' changed 
from 8 in kernel/built-in.o to 532 in ipc/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_mq_unlink' changed from 8 
in kernel/built-in.o to 272 in ipc/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_shmdt' changed from 8 in 
kernel/built-in.o to 412 in ipc/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_msgrcv' changed from 8 in 
kernel/built-in.o to 148 in ipc/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_mq_open' changed from 8 
in kernel/built-in.o to 840 in ipc/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_semget' changed from 8 in 
kernel/built-in.o to 176 in ipc/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_mq_timedsend' changed 
from 8 in kernel/built-in.o to 752 in ipc/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_semctl' changed from 8 in 
kernel/built-in.o to 2704 in ipc/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_mq_notify' changed from 8 
in kernel/built-in.o to 964 in ipc/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_semtimedop' changed from 
8 in kernel/built-in.o to 1820 in ipc/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_shmctl' changed from 8 in 
kernel/built-in.o to 2332 in ipc/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_mq_timedreceive' changed 
from 8 in kernel/built-in.o to 612 in ipc/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_msgsnd' changed from 8 in 
kernel/built-in.o to 124 in ipc/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_semop' changed from 8 in 
kernel/built-in.o to 16 in ipc/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_shmat' changed from 8 in 
kernel/built-in.o to 56 in ipc/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_msgctl' changed from 8 in 
kernel/built-in.o to 1804 in ipc/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_shmget' changed from 8 in 
kernel/built-in.o to 144 in ipc/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_recv' changed from 8 in 
kernel/built-in.o to 20 in net/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_setsockopt' changed from 
8 in kernel/built-in.o to 204 in net/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_recvfrom' changed from 8 
in kernel/built-in.o to 304 in net/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_socket' changed from 8 in 
kernel/built-in.o to 88 in net/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_socketcall' changed from 
8 in kernel/built-in.o to 452 in net/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_listen' changed from 8 in 
kernel/built-in.o to 124 in net/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_recvmsg' changed from 8 
in kernel/built-in.o to 592 in net/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_bind' changed from 8 in 
kernel/built-in.o to 168 in net/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_send' changed from 8 in 
kernel/built-in.o to 20 in net/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_accept' changed from 8 in 
kernel/built-in.o to 404 in net/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_sendto' changed from 8 in 
kernel/built-in.o to 300 in net/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_getsockname' changed from 
8 in kernel/built-in.o to 176 in net/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_getsockopt' changed from 
8 in kernel/built-in.o to 188 in net/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_shutdown' changed from 8 
in kernel/built-in.o to 112 in net/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_sendmsg' changed from 8 
in kernel/built-in.o to 680 in net/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_connect' changed from 8 
in kernel/built-in.o to 176 in net/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_socketpair' changed from 
8 in kernel/built-in.o to 524 in net/built-in.o
frv-linux-gnu-ld: Warning: size of symbol `sys_getpeername' changed from 
8 in kernel/built-in.o to 176 in net/built-in.o
   MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x40): Section mismatch: reference to 
.init.text:free_initmem (between 'init_post' and 'try_name')
WARNING: vmlinux.o(.text+0x54fc): Section mismatch: reference to 
.init.text:start_kernel (between 'debug_stub' and 'debug_stub_exit')
WARNING: vmlinux.o(.text+0x5500): Section mismatch: reference to 
.init.text:start_kernel (between 'debug_stub' and 'debug_stub_exit')
WARNING: vmlinux.o(.text+0xf7b48): Section mismatch: reference to 
.init.text:pcibios_fixup_bus (between 'pci_scan_child_bus' and 
'pci_scan_bridge')
   LD      vmlinux
   SYSMAP  System.map
   SYSMAP  .tmp_System.map
frv-linux-gnu-objcopy -O binary -R .note -R .comment -S vmlinux 
arch/frv/boot/Image
