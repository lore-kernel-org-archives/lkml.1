Return-Path: <linux-kernel-owner+w=401wt.eu-S965508AbXBFVSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965508AbXBFVSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965511AbXBFVSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:18:47 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:39303 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965508AbXBFVSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:18:44 -0500
Date: Tue, 6 Feb 2007 22:18:44 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Please pull git390 'for-linus' branch
Message-ID: <20070206211844.GD30335@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 Documentation/s390/Debugging390.txt                |    2 +-
 MAINTAINERS                                        |    6 +-
 arch/s390/Kconfig                                  |   29 +-
 arch/s390/appldata/appldata_base.c                 |    2 +-
 arch/s390/appldata/appldata_mem.c                  |    2 +-
 arch/s390/appldata/appldata_net_sum.c              |    2 +-
 arch/s390/crypto/Kconfig                           |   60 +
 arch/s390/crypto/Makefile                          |    3 +-
 arch/s390/crypto/aes_s390.c                        |   47 +-
 arch/s390/crypto/crypt_s390.h                      |  281 +++---
 arch/s390/crypto/crypt_s390_query.c                |  129 ---
 arch/s390/crypto/des_check_key.c                   |    6 +-
 arch/s390/crypto/des_s390.c                        |    8 +-
 arch/s390/crypto/prng.c                            |  213 ++++
 arch/s390/crypto/sha1_s390.c                       |   83 +-
 arch/s390/crypto/sha256_s390.c                     |   11 +-
 arch/s390/defconfig                                |   12 +-
 arch/s390/hypfs/Makefile                           |    2 +-
 arch/s390/hypfs/hypfs.h                            |    9 +
 arch/s390/hypfs/hypfs_diag.h                       |   16 -
 arch/s390/hypfs/hypfs_vm.c                         |  231 ++++
 arch/s390/hypfs/inode.c                            |   31 +-
 arch/s390/kernel/Makefile                          |    4 +-
 arch/s390/kernel/base.S                            |  150 +++
 arch/s390/kernel/binfmt_elf32.c                    |    2 +-
 arch/s390/kernel/compat_exec_domain.c              |    5 +-
 arch/s390/kernel/compat_linux.c                    |   24 +-
 arch/s390/kernel/compat_linux.h                    |   31 -
 arch/s390/kernel/compat_signal.c                   |    8 +-
 arch/s390/kernel/cpcmd.c                           |   14 +-
 arch/s390/kernel/crash.c                           |    1 +
 arch/s390/kernel/debug.c                           |   18 +-
 arch/s390/kernel/early.c                           |  307 +++++
 arch/s390/kernel/ebcdic.c                          |    1 +
 arch/s390/kernel/head31.S                          |  194 +---
 arch/s390/kernel/head64.S                          |  193 +----
 arch/s390/kernel/ipl.c                             |  106 ++-
 arch/s390/kernel/irq.c                             |   15 +-
 arch/s390/kernel/kprobes.c                         |   32 +-
 arch/s390/kernel/machine_kexec.c                   |    1 +
 arch/s390/kernel/module.c                          |    5 +-
 arch/s390/kernel/process.c                         |    4 +-
 arch/s390/kernel/profile.c                         |   20 -
 arch/s390/kernel/ptrace.c                          |   46 +-
 arch/s390/kernel/reset.S                           |   90 --
 arch/s390/kernel/s390_ext.c                        |    8 +-
 arch/s390/kernel/setup.c                           |  155 +++-
 arch/s390/kernel/signal.c                          |    2 +-
 arch/s390/kernel/smp.c                             |   41 +-
 arch/s390/kernel/stacktrace.c                      |   10 +-
 arch/s390/kernel/time.c                            | 1185 ++++++++++++++++++--
 arch/s390/kernel/traps.c                           |   24 +-
 arch/s390/kernel/vmlinux.lds.S                     |   13 +-
 arch/s390/kernel/vtime.c                           |   10 +-
 arch/s390/lib/Makefile                             |    2 +-
 arch/s390/lib/delay.c                              |   48 +-
 arch/s390/lib/qrnnd.S                              |   77 ++
 arch/s390/lib/uaccess.h                            |   23 +
 arch/s390/lib/uaccess_mvcos.c                      |   78 +-
 arch/s390/lib/uaccess_pt.c                         |  329 ++++++-
 arch/s390/lib/uaccess_std.c                        |   23 +-
 arch/s390/math-emu/Makefile                        |    2 +-
 arch/s390/math-emu/math.c                          |    2 +-
 arch/s390/math-emu/qrnnd.S                         |   77 --
 arch/s390/mm/cmm.c                                 |    4 +-
 arch/s390/mm/extmem.c                              |   66 +-
 arch/s390/mm/fault.c                               |   93 ++-
 arch/s390/mm/init.c                                |   20 +-
 arch/s390/mm/vmem.c                                |   14 +-
 crypto/Kconfig                                     |   49 -
 drivers/crypto/Kconfig                             |    2 +
 drivers/s390/Kconfig                               |    8 -
 drivers/s390/Makefile                              |    2 +
 drivers/s390/block/dasd.c                          |   33 +-
 drivers/s390/block/dasd_3990_erp.c                 |    5 -
 drivers/s390/block/dasd_devmap.c                   |    6 +-
 drivers/s390/block/dasd_diag.c                     |    8 +-
 drivers/s390/block/dasd_eckd.c                     |   95 +-
 drivers/s390/block/dasd_eer.c                      |   24 +-
 drivers/s390/block/dasd_erp.c                      |   80 --
 drivers/s390/block/dasd_fba.c                      |    4 +-
 drivers/s390/block/dasd_genhd.c                    |    2 +-
 drivers/s390/block/dasd_int.h                      |    1 -
 drivers/s390/block/dasd_proc.c                     |    8 +-
 drivers/s390/block/dcssblk.c                       |    6 +-
 drivers/s390/char/Makefile                         |    4 +-
 drivers/s390/char/con3215.c                        |    2 +-
 drivers/s390/char/con3270.c                        |    3 +-
 drivers/s390/char/defkeymap.c                      |    2 +
 drivers/s390/char/fs3270.c                         |    4 +-
 drivers/s390/char/keyboard.c                       |    2 +
 drivers/s390/char/monwriter.c                      |    4 +-
 drivers/s390/char/raw3270.c                        |    4 +-
 drivers/s390/char/sclp.c                           |   93 +-
 drivers/s390/char/sclp.h                           |   18 +-
 drivers/s390/char/sclp_con.c                       |    2 +-
 drivers/s390/char/sclp_cpi.c                       |    2 +-
 drivers/s390/char/sclp_info.c                      |   57 +
 drivers/s390/char/sclp_rw.c                        |    2 +-
 drivers/s390/char/sclp_tty.c                       |    2 +-
 drivers/s390/char/sclp_vt220.c                     |    4 +-
 drivers/s390/char/tape.h                           |   22 +-
 drivers/s390/char/tape_3590.c                      |  479 ++++++++-
 drivers/s390/char/tape_3590.h                      |   53 +-
 drivers/s390/char/tape_block.c                     |    4 +-
 drivers/s390/char/tape_char.c                      |   27 +-
 drivers/s390/char/tape_core.c                      |   69 +-
 drivers/s390/char/tty3270.c                        |   13 +-
 drivers/s390/char/vmlogrdr.c                       |    5 +-
 drivers/s390/cio/blacklist.c                       |   10 +-
 drivers/s390/cio/ccwgroup.c                        |    6 +-
 drivers/s390/cio/chsc.c                            |  270 +++---
 drivers/s390/cio/chsc.h                            |   11 +-
 drivers/s390/cio/cio.c                             |   37 +-
 drivers/s390/cio/cmf.c                             |    4 +-
 drivers/s390/cio/css.c                             |   13 +-
 drivers/s390/cio/css.h                             |    2 +
 drivers/s390/cio/device.c                          |   12 +-
 drivers/s390/cio/device.h                          |    2 +
 drivers/s390/cio/device_fsm.c                      |    8 +-
 drivers/s390/cio/device_ops.c                      |   34 +-
 drivers/s390/cio/device_status.c                   |    8 +-
 drivers/s390/cio/qdio.c                            |   79 +-
 drivers/s390/crypto/ap_bus.c                       |    8 +-
 drivers/s390/crypto/zcrypt_api.c                   |   20 +-
 drivers/s390/crypto/zcrypt_pcica.c                 |    8 +-
 drivers/s390/crypto/zcrypt_pcixcc.c                |    3 +-
 drivers/s390/net/claw.c                            |   16 +-
 drivers/s390/net/ctcmain.c                         |    8 +-
 drivers/s390/net/cu3088.c                          |    2 +-
 drivers/s390/net/lcs.c                             |    6 +-
 drivers/s390/net/netiucv.c                         |    4 +-
 drivers/s390/net/qeth_eddp.c                       |   28 +-
 drivers/s390/net/qeth_main.c                       |   92 +-
 drivers/s390/net/qeth_sys.c                        |   30 +-
 drivers/s390/s390mach.c                            |   37 +-
 drivers/s390/s390mach.h                            |    3 +
 drivers/s390/scsi/zfcp_aux.c                       |   25 +-
 drivers/s390/scsi/zfcp_dbf.c                       |   44 +-
 drivers/s390/scsi/zfcp_erp.c                       |    7 +-
 drivers/s390/scsi/zfcp_ext.h                       |    4 +-
 drivers/s390/scsi/zfcp_fsf.c                       |    2 +-
 drivers/s390/scsi/zfcp_qdio.c                      |   38 +-
 drivers/s390/scsi/zfcp_scsi.c                      |   18 +-
 drivers/s390/sysinfo.c                             |   63 +-
 include/asm-s390/ccwdev.h                          |    2 +
 include/asm-s390/compat.h                          |   28 +
 include/asm-s390/etr.h                             |  219 ++++
 include/asm-s390/hardirq.h                         |    2 +-
 include/asm-s390/io.h                              |    4 -
 include/asm-s390/kdebug.h                          |    3 +-
 include/asm-s390/lowcore.h                         |    6 +-
 include/asm-s390/mmu_context.h                     |   50 +-
 include/asm-s390/pgalloc.h                         |   85 ++-
 include/asm-s390/pgtable.h                         |  147 +++-
 include/asm-s390/processor.h                       |   27 +-
 include/asm-s390/ptrace.h                          |   11 +-
 include/asm-s390/reset.h                           |    3 -
 include/asm-s390/sclp.h                            |   39 +
 include/asm-s390/sections.h                        |    2 +
 include/asm-s390/setup.h                           |   23 +-
 .../s390/math-emu => include/asm-s390}/sfp-util.h  |    6 +-
 include/asm-s390/smp.h                             |    6 +-
 include/asm-s390/system.h                          |    4 +-
 include/asm-s390/tape390.h                         |   72 ++-
 include/asm-s390/timer.h                           |    3 +
 include/asm-s390/timex.h                           |   50 +
 include/asm-s390/tlbflush.h                        |    9 +
 include/asm-s390/uaccess.h                         |    2 +
 169 files changed, 5560 insertions(+), 2177 deletions(-)
 create mode 100644 arch/s390/crypto/Kconfig
 delete mode 100644 arch/s390/crypto/crypt_s390_query.c
 create mode 100644 arch/s390/crypto/prng.c
 delete mode 100644 arch/s390/hypfs/hypfs_diag.h
 create mode 100644 arch/s390/hypfs/hypfs_vm.c
 create mode 100644 arch/s390/kernel/base.S
 create mode 100644 arch/s390/kernel/early.c
 delete mode 100644 arch/s390/kernel/profile.c
 delete mode 100644 arch/s390/kernel/reset.S
 create mode 100644 arch/s390/lib/qrnnd.S
 create mode 100644 arch/s390/lib/uaccess.h
 delete mode 100644 arch/s390/math-emu/qrnnd.S
 create mode 100644 drivers/s390/char/sclp_info.c
 create mode 100644 include/asm-s390/etr.h
 create mode 100644 include/asm-s390/sclp.h
 rename arch/s390/math-emu/sfp-util.h => include/asm-s390/sfp-util.h (91%)

Akinobu Mita (1):
      [S390] Check the return value of kthread_run().

Christian Borntraeger (1):
      [S390] cpcmd with vmalloc addresses.

Cornelia Huck (6):
      [S390] cio: Remove check for ssd in chpids_show().
      [S390] cio: Restart path verification after unsolicited interrupt.
      [S390] cio: Use device_{create,remove}_bin_file.
      [S390] cio: Catch operand exceptions on stsch.
      [S390] cio: Don't spam debug feature.
      [S390] cio: Fixup interface for setting options on ccw devices.

Gerald Schaefer (2):
      [S390] Show loaded DCSS segments under /proc/iomem.
      [S390] noexec protection

Heiko Carstens (15):
      [S390] Move init_irq_proc to the other irq related functions.
      [S390] Get rid of a lot of sparse warnings.
      [S390] Remove pointless/unreliable kernel messages.
      [S390] Simplify virt_to_phys.
      [S390] Fix FCP dump feature detection.
      [S390] sclp: don't call local_bh_disable/_local_bh_enable if in_interrupt()
      [S390] Small barrier() and cpu_relax() cleanup.
      [S390] Fix kprobes breakpoint handling.
      [S390] kretprobe_trampoline_holder() in wrong section.
      [S390] Fix register usage description.
      [S390] Add set_fs(USER_DS) to start_thread().
      [S390] Add/extend WARN_ONs in smp_call_function & smp_call_function_on.
      [S390] Convert memory detection into C code.
      [S390] Mark kernel text section read-only.
      [S390] Avoid excessive inlining.

Hongjie Yang (1):
      [S390] boot from NSS support

Horst Hummel (2):
      [S390] Remove dasd_ccw_log function.
      [S390] dasd: fix unconditional reserve handling.

Jan Glauber (2):
      [S390] move crypto options and some cleanup.
      [S390] Support for s390 Pseudo Random Number Generator

Martin Schwidefsky (3):
      [S390] Update maintainers file.
      [S390] ETR support.
      [S390] Calibrate delay and bogomips.

Michael Holzheu (2):
      [S390] Add crypto support for 3592 tape devices
      [S390] Hypervisor filesystem (s390_hypfs) for z/VM

Peter Oberparleiter (3):
      [S390] sclp: invalid handling of temporary 'not operational' status
      [S390] cio: declare hardware structures packed.
      [S390] Cleanup of CHSC event handling.

Stefan Weinhuber (1):
      [S390] dasd: fix bug in dasd initialization cleanup

Patch size > 100KB. Skipped.

