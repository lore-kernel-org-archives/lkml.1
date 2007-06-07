Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbXFGHEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbXFGHEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbXFGHED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:04:03 -0400
Received: from holomorphy.com ([66.93.40.71]:47771 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbXFGHEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:04:02 -0400
Date: Thu, 7 Jun 2007 00:05:13 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm2
Message-ID: <20070607070513.GT6909@holomorphy.com>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <20070607064231.GQ6909@holomorphy.com> <20070606235131.a56242cd.akpm@linux-foundation.org> <20070607065544.GR6909@holomorphy.com> <20070607000125.40ba8dc6.akpm@linux-foundation.org> <20070607070407.GS6909@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607070407.GS6909@holomorphy.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 12:01:25AM -0700, Andrew Morton wrote:
>> config, please?

On Thu, Jun 07, 2007 at 12:04:07AM -0700, William Lee Irwin III wrote:
> It's the sparc32 defconfig. Included below for completeness.

The error output looks like the following.


-- wli

$ quilt top                                                                     create-the-zone_movable-zone-fix.patch                                          $ (yes "" | make ARCH=sparc CROSS_COMPILE="sparc-linux-" CC="gcc-sparc-4.1" quiet=1 -j16 defconfig) >& /dev/null; yes "" | make ARCH=sparc CROSS_COMPILE="sparc-linux-" CC="gcc-sparc-4.1" quiet=1 -j16 image modules                           scripts/kconfig/conf -s arch/sparc/Kconfig
drivers/macintosh/Kconfig:116:warning: 'select' used by config symbol 'PMAC_APM_EMU' refers to undefined symbol 'APM_EMULATION'
drivers/input/keyboard/Kconfig:170:warning: 'select' used by config symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
drivers/input/mouse/Kconfig:182:warning: 'select' used by config symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
sound/soc/sh/Kconfig:6:warning: 'select' used by config symbol 'SND_SOC_PCM_SH7760' refers to undefined symbol 'SH_DMABRG'
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/linux/utsrelease.h
  UPD     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-sparc
<stdin>:752:2: warning: #warning syscall setresuid not implemented
<stdin>:756:2: warning: #warning syscall getresuid not implemented
<stdin>:776:2: warning: #warning syscall setresgid not implemented
<stdin>:780:2: warning: #warning syscall getresgid not implemented
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
ipc/msg.c: In function 'sys_msgctl':
ipc/msg.c:390: warning: 'setbuf.qbytes' may be used uninitialized in this function
ipc/msg.c:390: warning: 'setbuf.uid' may be used uninitialized in this function
ipc/msg.c:390: warning: 'setbuf.gid' may be used uninitialized in this function
ipc/msg.c:390: warning: 'setbuf.mode' may be used uninitialized in this function
ipc/sem.c: In function 'sys_semctl':
ipc/sem.c:861: warning: 'setbuf.uid' may be used uninitialized in this function
ipc/sem.c:861: warning: 'setbuf.gid' may be used uninitialized in this function
ipc/sem.c:861: warning: 'setbuf.mode' may be used uninitialized in this function
mm/vmalloc.c: In function 'unmap_kernel_range':
mm/vmalloc.c:75: warning: unused variable 'start'
drivers/char/rtc.c:118: warning: 'hpet_rtc_interrupt' defined but not used
kernel/time/ntp.c: In function 'do_adjtimex':
kernel/time/ntp.c:309: warning: comparison of distinct pointer types lacks a cast
kernel/time/ntp.c:312: warning: comparison of distinct pointer types lacks a cast
drivers/pci/search.c: In function 'pci_find_slot':
drivers/pci/search.c:99: warning: 'pci_find_device' is deprecated (declared at include/linux/pci.h:478)
drivers/pci/search.c: At top level:
drivers/pci/search.c:434: warning: 'pci_find_device' is deprecated (declared at drivers/pci/search.c:241)
drivers/pci/search.c:434: warning: 'pci_find_device' is deprecated (declared at drivers/pci/search.c:241)
drivers/pci/search.c:435: warning: 'pci_find_slot' is deprecated (declared at drivers/pci/search.c:96)
drivers/pci/search.c:435: warning: 'pci_find_slot' is deprecated (declared at drivers/pci/search.c:96)
drivers/pci/syscall.c: In function 'sys_pciconfig_read':
drivers/pci/syscall.c:22: warning: 'dev' may be used uninitialized in this function
fs/partitions/check.c: In function 'add_partition':
fs/partitions/check.c:392: warning: ignoring return value of 'kobject_add', declared with attribute warn_unused_result
fs/partitions/check.c:395: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
fs/partitions/check.c:402: warning: ignoring return value of 'sysfs_create_file', declared with attribute warn_unused_result
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
WARNING: arch/sparc/kernel/head.o(.text+0x9040): Section mismatch: reference to .init.text:no_sun4u_here (between 'current_pc' and 'already_mapped')
WARNING: arch/sparc/kernel/head.o(.text+0x9280): Section mismatch: reference to .init.text:execute_in_high_mem (after 'go_to_highmem')
WARNING: arch/sparc/kernel/head.o(.text+0x9284): Section mismatch: reference to .init.text:execute_in_high_mem (after 'go_to_highmem')
  Building modules, stage 2.
WARNING: vmlinux(.text+0x9040): Section mismatch: reference to .init.text:no_sun4u_here (between 'current_pc' and 'already_mapped')
WARNING: vmlinux(.text+0x9280): Section mismatch: reference to .init.text:execute_in_high_mem (between 'go_to_highmem' and 'init_thread_union')
WARNING: vmlinux(.text+0x9284): Section mismatch: reference to .init.text:execute_in_high_mem (between 'go_to_highmem' and 'init_thread_union')
WARNING: vmlinux(.text+0x1dfb38): Section mismatch: reference to .init.text:kernel_init (between 'rest_init' and 'alloc_node_mem_map')
WARNING: vmlinux(.text+0x1dfb40): Section mismatch: reference to .init.text:kernel_init (between 'rest_init' and 'alloc_node_mem_map')
WARNING: vmlinux(.text+0x1dfbf8): Section mismatch: reference to .init.text:__alloc_bootmem_node (between 'alloc_node_mem_map' and 'zone_wait_table_init')
WARNING: vmlinux(.text+0x1dfcfc): Section mismatch: reference to .init.text:__alloc_bootmem_node (between 'zone_wait_table_init' and 'setup_cpu_cache')
WARNING: vmlinux(.text+0x1dfe20): Section mismatch: reference to .init.text:set_up_list3s (between 'setup_cpu_cache' and '__down')
WARNING: vmlinux(.text+0x1dfe94): Section mismatch: reference to .init.text:set_up_list3s (between 'setup_cpu_cache' and '__down')
ERROR: "movable_zone" [fs/romfs/romfs.ko] undefined!
ERROR: "movable_zone" [fs/isofs/isofs.ko] undefined!
ERROR: "movable_zone" [fs/cifs/cifs.ko] undefined!
ERROR: "movable_zone" [fs/afs/kafs.ko] undefined!
ERROR: "movable_zone" [drivers/block/loop.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
make: *** Waiting for unfinished jobs....
arch/sparc/mm/built-in.o: In function `kmap_atomic':
(.text+0x433c): undefined reference to `movable_zone'
arch/sparc/mm/built-in.o: In function `kmap_atomic':
(.text+0x4348): undefined reference to `movable_zone'
mm/built-in.o: In function `iov_iter_copy_from_user':
(.text+0x770): undefined reference to `movable_zone'
mm/built-in.o: In function `iov_iter_copy_from_user':
(.text+0x844): undefined reference to `movable_zone'
mm/built-in.o: In function `iov_iter_copy_from_user':
(.text+0x850): undefined reference to `movable_zone'
mm/built-in.o:(.text+0x870): more undefined references to `movable_zone' follow
make[1]: *** [arch/sparc/boot/image] Error 1
make: *** [image] Error 2
