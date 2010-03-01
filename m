Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337Ab0CAMme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 07:42:34 -0500
Received: from smh1-gp.mediaserv.net ([213.188.172.31]:53207 "EHLO
	smhav-gp.mediaserv.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751192Ab0CAMmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 07:42:33 -0500
From: werner@guyane.dyn-o-saur.com
Subject: 2.6.33-git6 problem
To: linux-kernel@vger.kernel.org
X-Originating-IP: 127.0.0.1
X-Mailer: Usermin 1.360
Message-Id: <1267446083.16093@guyane.dyn-o-saur.com>
Date: Mon, 01 Mar 2010 09:21:23 -0300 (GFT)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1267446083"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--bound1267446083
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

before, these errors didn't occur
....
  CC      arch/x86/lib/strstr_32.o
  AS      arch/x86/lib/thunk_32.o
  CC      arch/x86/lib/usercopy_32.o
  AR      arch/x86/lib/lib.a
  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: modpost: Found 9 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `compal_rfkill_poll':
compal-laptop.c:(.text+0x6317cf): undefined reference to `rfkill_set_hw_state'
drivers/built-in.o: In function `compal_init':
compal-laptop.c:(.init.text+0x3967d): undefined reference to `rfkill_alloc'
compal-laptop.c:(.init.text+0x3968d): undefined reference to `rfkill_register'
compal-laptop.c:(.init.text+0x396b2): undefined reference to `rfkill_alloc'
compal-laptop.c:(.init.text+0x396c7): undefined reference to `rfkill_register'
compal-laptop.c:(.init.text+0x396d7): undefined reference to `rfkill_destroy'
compal-laptop.c:(.init.text+0x396e1): undefined reference to `rfkill_unregister'
compal-laptop.c:(.init.text+0x396eb): undefined reference to `rfkill_destroy'
drivers/built-in.o: In function `compal_cleanup':
compal-laptop.c:(.exit.text+0x6b4b): undefined reference to `rfkill_unregister'
compal-laptop.c:(.exit.text+0x6b55): undefined reference to `rfkill_destroy'
compal-laptop.c:(.exit.text+0x6b5f): undefined reference to `rfkill_unregister'
compal-laptop.c:(.exit.text+0x6b69): undefined reference to `rfkill_destroy'
make: [.tmp_vmlinux1] Error 1 (ignored)
  KSYM    .tmp_kallsyms1.S
nm: '.tmp_vmlinux1': No such file
No valid symbol.
make: [.tmp_kallsyms1.S] Error 1 (ignored)
  AS      .tmp_kallsyms1.o
  LD      .tmp_vmlinux2
drivers/built-in.o: In function `compal_rfkill_poll':
compal-laptop.c:(.text+0x6317cf): undefined reference to `rfkill_set_hw_state'
drivers/built-in.o: In function `compal_init':
compal-laptop.c:(.init.text+0x3967d): undefined reference to `rfkill_alloc'
compal-laptop.c:(.init.text+0x3968d): undefined reference to `rfkill_register'
compal-laptop.c:(.init.text+0x396b2): undefined reference to `rfkill_alloc'
compal-laptop.c:(.init.text+0x396c7): undefined reference to `rfkill_register'
compal-laptop.c:(.init.text+0x396d7): undefined reference to `rfkill_destroy'
compal-laptop.c:(.init.text+0x396e1): undefined reference to `rfkill_unregister'
compal-laptop.c:(.init.text+0x396eb): undefined reference to `rfkill_destroy'
drivers/built-in.o: In function `compal_cleanup':
compal-laptop.c:(.exit.text+0x6b4b): undefined reference to `rfkill_unregister'
compal-laptop.c:(.exit.text+0x6b55): undefined reference to `rfkill_destroy'
compal-laptop.c:(.exit.text+0x6b5f): undefined reference to `rfkill_unregister'
compal-laptop.c:(.exit.text+0x6b69): undefined reference to `rfkill_destroy'
make: [.tmp_vmlinux2] Error 1 (ignored)
  KSYM    .tmp_kallsyms2.S
nm: '.tmp_vmlinux2': No such file
No valid symbol.
make: [.tmp_kallsyms2.S] Error 1 (ignored)
  AS      .tmp_kallsyms2.o
  LD      vmlinux
drivers/built-in.o: In function `compal_rfkill_poll':
compal-laptop.c:(.text+0x6317cf): undefined reference to `rfkill_set_hw_state'
drivers/built-in.o: In function `compal_init':
compal-laptop.c:(.init.text+0x3967d): undefined reference to `rfkill_alloc'
compal-laptop.c:(.init.text+0x3968d): undefined reference to `rfkill_register'
compal-laptop.c:(.init.text+0x396b2): undefined reference to `rfkill_alloc'
compal-laptop.c:(.init.text+0x396c7): undefined reference to `rfkill_register'
compal-laptop.c:(.init.text+0x396d7): undefined reference to `rfkill_destroy'
compal-laptop.c:(.init.text+0x396e1): undefined reference to `rfkill_unregister'
compal-laptop.c:(.init.text+0x396eb): undefined reference to `rfkill_destroy'
drivers/built-in.o: In function `compal_cleanup':
compal-laptop.c:(.exit.text+0x6b4b): undefined reference to `rfkill_unregister'
compal-laptop.c:(.exit.text+0x6b55): undefined reference to `rfkill_destroy'
compal-laptop.c:(.exit.text+0x6b5f): undefined reference to `rfkill_unregister'
compal-laptop.c:(.exit.text+0x6b69): undefined reference to `rfkill_destroy'
make: [vmlinux] Error 1 (ignored)
  SYSMAP  System.map
nm: 'vmlinux': No such file
make: [vmlinux] Error 1 (ignored)
  SYSMAP  .tmp_System.map
nm: '.tmp_vmlinux2': No such file
make: [vmlinux] Error 1 (ignored)
  CC      arch/x86/boot/a20.o
  AS      arch/x86/boot/bioscall.o
  CC      arch/x86/boot/cmdline.o
  AS      arch/x86/boot/copy.o
  HOSTCC  arch/x86/boot/mkcpustr
  CPUSTR  arch/x86/boot/cpustr.h
  CC      arch/x86/boot/cpu.o
  CC      arch/x86/boot/cpucheck.o
  CC      arch/x86/boot/edd.o
make[1]: *** No rule to make target `vmlinux', needed by `arch/x86/boot/voffset.h'.
  LDS     arch/x86/boot/compressed/vmlinux.lds
  AS      arch/x86/boot/compressed/head_32.o
  CC      arch/x86/boot/compressed/misc.o
make[2]: *** No rule to make target `vmlinux', needed by `arch/x86/boot/compressed/vmlinux.bin'.
  HOSTCC  arch/x86/boot/compressed/mkpiggy
make[2]: Target `arch/x86/boot/compressed/vmlinux' not remade because of errors.
make[1]: [arch/x86/boot/compressed/vmlinux] Error 2 (ignored)
  ZOFFSET arch/x86/boot/zoffset.h
nm: 'arch/x86/boot/compressed/vmlinux': No such file
  CC      arch/x86/boot/main.o
  CC      arch/x86/boot/mca.o
  CC      arch/x86/boot/memory.o
  CC      arch/x86/boot/pm.o
  AS      arch/x86/boot/pmjump.o
  CC      arch/x86/boot/printf.o
  CC      arch/x86/boot/regs.o
  CC      arch/x86/boot/string.o
  CC      arch/x86/boot/tty.o
  CC      arch/x86/boot/video.o
  CC      arch/x86/boot/video-mode.o
  CC      arch/x86/boot/version.o
  CC      arch/x86/boot/apm.o
  CC      arch/x86/boot/video-vga.o
  CC      arch/x86/boot/video-vesa.o
  CC      arch/x86/boot/video-bios.o
  OBJCOPY arch/x86/boot/vmlinux.bin
objcopy: 'arch/x86/boot/compressed/vmlinux': No such file
make[1]: [arch/x86/boot/vmlinux.bin] Error 1 (ignored)
  HOSTCC  arch/x86/boot/tools/build
make[1]: Target `arch/x86/boot/bzImage' not remade because of errors.
make: [bzImage] Error 2 (ignored)
  Building modules, stage 2.
  MODPOST 2169 modules
WARNING: modpost: Found 10 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  CC      arch/x86/crypto/crc32c-intel.mod.o
  LD [M]  arch/x86/crypto/crc32c-intel.ko
  CC      arch/x86/crypto/salsa20-i586.mod.o
  LD [M]  arch/x86/crypto/salsa20-i586.ko
  CC      arch/x86/kvm/kvm-amd.mod.o
  LD [M]  arch/x86/kvm/kvm-amd.ko
  CC      arch/x86/kvm/kvm-intel.mod.o
  LD [M]  arch/x86/kvm/kvm-intel.ko
  CC      arch/x86/kvm/kvm.mod.o
  LD [M]  arch/x86/kvm/kvm.ko
  CC      crypto/ccm.mod.o
  LD [M]  crypto/ccm.ko
  CC      crypto/cryptd.mod.o
  LD [M]  crypto/cryptd.ko
  CC      crypto/ctr.mod.o
....

--bound1267446083--

