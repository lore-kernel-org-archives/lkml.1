Return-Path: <linux-kernel-owner+w=401wt.eu-S1762736AbYBRVFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762736AbYBRVFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762223AbYBRVD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:03:59 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54260 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762203AbYBRVD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:03:57 -0500
To: jdike@addtoit.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <E1JQ6bM-0005z4-Ac@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Fri, 15 Feb 2008 20:52:04 +0100)
Subject: [bug] uml doesn't boot under 2.6.25-rc1 host (was Re: 2.6.24-mm1 bugs)
References: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu> <20080215184741.GB8810@c2.user-mode-linux.org> <E1JQ6bM-0005z4-Ac@pomaz-ex.szeredi.hu>
Message-Id: <E1JRD9I-0004L9-6E@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Feb 2008 22:03:40 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >  - UML doesn't boot: guest is 2.6.24-mm1 also, haven't tried any
> > >    other.  Same guest boots fine on 2.6.24 host.
> > 
> > What does it do?
> 
> See below.

This bug seems to have made it to mainline as well, starting with
-rc1.  Any ideas?  Should I start bisecting?

Thanks,
Miklos

> 
> > 
> > Any chance you can bisect it?
> 
> It would be a bit painful, because this is the only machine I can use.
> I much prefer bisecting UML kernels :)
> 
> Thanks,
> Miklos
> 
> 
> 
> 
> GNU gdb 6.6.50.20070726-cvs
> Copyright (C) 2007 Free Software Foundation, Inc.
> GDB is free software, covered by the GNU General Public License, and you are
> welcome to change it and/or distribute copies of it under certain conditions.
> Type "show copying" to see the conditions.
> There is absolutely no warranty for GDB.  Type "show warranty" for details.
> This GDB was configured as "x86_64-suse-linux"...
> Using host libthread_db library "/lib64/libthread_db.so.1".
> (gdb) r umid=uml
> Starting program: /store/quilt/linux/linux umid=uml
> Core dump limits :
>         soft - 0
>         hard - NONE
> Checking that ptrace can change system call numbers...OK
> Checking syscall emulation patch for ptrace...missing
> Checking for tmpfs mount on /dev/shm...nothing mounted on /dev/shm
> Checking PROT_EXEC mmap in /tmp/...OK
> Checking for the skas3 patch in the host:
>   - /proc/mm...not found: No such file or directory
>   - PTRACE_FAULTINFO...not found: Invalid argument
>   - PTRACE_LDT...not found: Invalid argument
> UML running in SKAS0 mode
> Adding 24977408 bytes to physical memory to account for exec-shield gap
> [    0.000000] Linux version 2.6.24-mm1 (mszeredi@tucsk) (gcc version 4.2.1 (SUSE Linux)) #26 Fri Feb 15 11:05:54 CET 2008
> [    0.010000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 14179
> [    0.010000] Kernel command line: root=98:0
> [    0.010000] PID hash table entries: 256 (order: 8, 1024 bytes)
> [    0.010000] Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
> [    0.010000] Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
> [    0.010000] Memory: 29504k available
> [    0.270000] Mount-cache hash table entries: 512
> [    0.270000] Checking for host processor cmov support...Yes
> [    0.270000] Checking that host ptys support output SIGIO...Yes
> [    0.270000] Checking that host ptys support SIGIO on close...No, enabling workaround
> [    0.270000] net_namespace: 184 bytes
> [    0.270000] Using 2.6 host AIO
> [    0.270000] NET: Registered protocol family 16
> [    0.300000] NET: Registered protocol family 2
> [    0.310000] Time: itimer clocksource has been installed.
> [    0.390000] IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
> [    0.390000] TCP established hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.390000] TCP bind hash table entries: 2048 (order: 3, 40960 bytes)
> [    0.390000] TCP: Hash tables configured (established 2048 bind 2048)
> [    0.390000] TCP reno registered
> [    0.420000] Checking host MADV_REMOVE support...<3>MADV_REMOVE failed, err = -38
> [    0.420000] Can't release memory to the host - memory hotplug won't be supported
> [    0.420000] mconsole (version 2) initialized on /home/mszeredi/.uml/uml/mconsole
> [    0.420000] Host TLS support detected
> [    0.420000] Detected host type: x86_64 (GDT indexes 12 to 15)
> [    0.420000] fuse init (API version 7.9)
> [    0.420000] io scheduler noop registered (default)
> [    0.420000] loop: module loaded
> [    0.420000] TCP cubic registered
> [    0.420000] NET: Registered protocol family 1
> [    0.420000] Initialized stdio console driver
> [    0.420000] Console initialized on /dev/tty0
> [    0.420000] console [tty0] enabled
> [    0.420000] console [mc-1] enabled
> [    0.420000]  ubda: unknown partition table
> [    0.420000] kjournald starting.  Commit interval 5 seconds
> [    0.420000] EXT3-fs: mounted filesystem with ordered data mode.
> [    0.420000] VFS: Mounted root (ext3 filesystem) readonly.
> [    0.420000] Failed to get registers from stub, errno = 3
> [    0.420000] wait_stub_done : failed to wait for SIGTRAP, pid = 30073, n = 30073, errno = 0, status = 0x0
> [New LWP 30070]
>                [New LWP 30071]
>                               [New LWP 30072]
> 
> Program received signal SIGTERM, Terminated.
> 0xffffe430 in __kernel_vsyscall ()
> (gdb) bt
> #0  0xffffe430 in __kernel_vsyscall ()
> #1  0xf7eabc26 in kill () from /lib/libc.so.6
> #2  0x0806cf82 in os_dump_core () at arch/um/os-Linux/util.c:105
> #3  0x0805d64d in fatal_sigsegv () at arch/um/kernel/trap.c:141
> #4  0x0806e32b in wait_stub_done (pid=30073)
>     at arch/um/os-Linux/skas/process.c:94
> #5  0x0806d94b in run_syscall_stub (mm_idp=0xb26ff18, syscall=123,
>     args=0xb067e08, expected=0, addr=0xb067ea4, done=1)
>     at arch/um/os-Linux/skas/mem.c:86
> #6  0x0806f997 in write_ldt_entry (mm_idp=0xb26ff18, func=1, desc=0xb067e94,
>     addr=0xb067ea4, done=1) at arch/um/sys-i386/ldt.c:72
> #7  0x08070434 in init_new_ldt (new_mm=0xb26ff18, from_mm=0x0)
>     at arch/um/sys-i386/ldt.c:425
> #8  0x0805de43 in init_new_context (task=0xb05bc00, mm=0xb26fdc0)
>     at arch/um/kernel/skas/mmu.c:87
> #9  0x080ce3c1 in bprm_mm_init (bprm=0xb1a6980) at fs/exec.c:337
> #10 0x080cfa2d in do_execve (filename=0x820d61f "/sbin/init", argv=0x8250020,
>     envp=0x8250240, regs=0xb05be04) at fs/exec.c:1296
> #11 0x080599e8 in execve1 (file=0x820d61f "/sbin/init", argv=0x8250020,
>     env=0x8250240) at arch/um/kernel/exec.c:62
> #12 0x08059a4f in um_execve (file=0x820d61f "/sbin/init", argv=0x8250020,
>     env=0x8250240) at arch/um/kernel/exec.c:78
> #13 0x0805c4fb in kernel_execve (filename=0x820d61f "/sbin/init",
> ---Type <return> to continue, or q <return> to quit---
>     argv=0x8250020, envp=0x8250240) at arch/um/kernel/syscall.c:146
> #14 0x08059616 in run_init_process (init_filename=0x820d61f "/sbin/init")
>     at init/main.c:763
> #15 0x080596d3 in init_post () at init/main.c:809
> #16 0x08049a74 in kernel_init (unused=0x0) at init/main.c:865
> #17 0x0806ac31 in run_kernel_thread (fn=0x8049a00 <kernel_init>, arg=0x0,
>     jmp_ptr=0xb05be70) at arch/um/os-Linux/process.c:267
> #18 0x0805ad62 in new_thread_handler () at arch/um/kernel/process.c:153
> #19 0x00000000 in ?? ()
> (gdb)
> 
