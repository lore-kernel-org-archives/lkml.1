Return-Path: <linux-kernel-owner+w=401wt.eu-S1762169AbZCQBYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762169AbZCQBYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 21:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759587AbZCQBXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 21:23:19 -0400
Received: from kroah.org ([198.145.64.141]:59197 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752977AbZCQBXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 21:23:11 -0400
Date: Mon, 16 Mar 2009 18:21:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.27.20
Message-ID: <20090317012150.GC32410@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.20 kernel.

I'll also be replying to this message with a copy of the patch between
2.6.27.18 and 2.6.27.20

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                              |    2 
 arch/arm/mach-rpc/riscpc.c            |    6 +
 arch/ia64/include/asm/mmzone.h        |    4 
 arch/ia64/mm/numa.c                   |    4 
 arch/powerpc/include/asm/compat.h     |    5 +
 arch/powerpc/include/asm/seccomp.h    |    4 
 arch/powerpc/kernel/align.c           |   29 ++---
 arch/sparc/include/asm/compat.h       |    5 +
 arch/sparc/include/asm/ptrace_32.h    |   10 ++
 arch/sparc/include/asm/ptrace_64.h    |   10 ++
 arch/sparc/include/asm/seccomp.h      |    6 -
 arch/sparc64/kernel/traps.c           |   17 +++
 arch/x86/ia32/ia32entry.S             |    8 +
 arch/x86/kernel/cpu/mtrr/main.c       |    3 
 arch/x86/kernel/io_apic_64.c          |    2 
 arch/x86/kernel/ptrace.c              |    2 
 arch/x86/kernel/reboot.c              |    8 +
 arch/x86/kernel/vmiclock_32.c         |    5 -
 arch/x86/mm/numa_64.c                 |    2 
 arch/x86/xen/enlighten.c              |    3 
 drivers/acpi/ec.c                     |    5 -
 drivers/ata/libata-core.c             |   10 +-
 drivers/ata/libata-eh.c               |    5 -
 drivers/atm/fore200e.c                |    4 
 drivers/block/aoe/aoe.h               |    1 
 drivers/block/aoe/aoenet.c            |    2 
 drivers/block/xen-blkfront.c          |   30 +++---
 drivers/char/agp/intel-agp.c          |    8 +
 drivers/hwmon/f71882fg.c              |    2 
 drivers/hwmon/it87.c                  |    8 -
 drivers/i2c/busses/i2c-acorn.c        |    3 
 drivers/i2c/busses/i2c-amd8111.c      |    4 
 drivers/i2c/busses/i2c-pxa.c          |    2 
 drivers/i2c/i2c-core.c                |    3 
 drivers/ide/ide-iops.c                |    2 
 drivers/infiniband/hw/nes/nes_cm.c    |   37 ++++++-
 drivers/infiniband/hw/nes/nes_verbs.c |    2 
 drivers/infiniband/hw/nes/nes_verbs.h |    1 
 drivers/md/raid1.c                    |    3 
 drivers/md/raid10.c                   |   19 ++-
 drivers/media/common/tuners/tda8290.c |    3 
 drivers/media/dvb/frontends/s5h1409.c |    7 -
 drivers/media/video/ivtv/ivtv-ioctl.c |   24 ++--
 drivers/misc/hpilo.c                  |    1 
 drivers/mmc/card/mmc_test.c           |    2 
 drivers/mmc/host/s3cmci.c             |    3 
 drivers/mmc/host/sdhci.c              |    4 
 drivers/mmc/host/sdhci.h              |    1 
 drivers/mtd/devices/mtd_dataflash.c   |    3 
 drivers/net/sis190.c                  |    1 
 drivers/net/usb/asix.c                |   12 ++
 drivers/net/usb/cdc_ether.c           |    5 +
 drivers/net/usb/zaurus.c              |    5 +
 drivers/net/wireless/rtl8187_dev.c    |   12 ++
 drivers/pci/pcie/aer/aerdrv_core.c    |   48 +++++++--
 drivers/pci/pcie/portdrv_pci.c        |    3 
 drivers/pci/quirks.c                  |   29 +++++
 drivers/scsi/hptiop.c                 |    1 
 drivers/scsi/sd.c                     |    7 +
 drivers/serial/8250.c                 |   15 +++
 drivers/serial/8250_pci.c             |   36 +++++++
 drivers/serial/jsm/jsm_driver.c       |    3 
 drivers/usb/class/cdc-acm.c           |    2 
 drivers/usb/core/message.c            |   11 +-
 drivers/usb/host/ehci-hcd.c           |    2 
 drivers/usb/host/ehci-mem.c           |    1 
 drivers/usb/host/ehci-sched.c         |   56 +++++++++--
 drivers/usb/host/ehci.h               |    6 +
 drivers/usb/serial/option.c           |    5 +
 drivers/usb/storage/unusual_devs.h    |    4 
 drivers/watchdog/ks8695_wdt.c         |    1 
 drivers/watchdog/rc32434_wdt.c        |  168 +++++++++++++---------------------
 fs/cifs/CHANGES                       |    2 
 fs/cifs/sess.c                        |    4 
 fs/compat_ioctl.c                     |    2 
 fs/ext4/ext4.h                        |    2 
 fs/ext4/ialloc.c                      |    7 +
 fs/ext4/inode.c                       |   15 ++-
 fs/ext4/mballoc.c                     |   32 +++---
 fs/ext4/migrate.c                     |    8 -
 fs/ext4/super.c                       |   12 +-
 fs/fs-writeback.c                     |    9 +
 fs/inode.c                            |    7 +
 fs/inotify.c                          |    2 
 fs/jbd2/journal.c                     |   17 ++-
 fs/jbd2/transaction.c                 |   42 ++++++--
 fs/jffs2/readinode.c                  |   42 ++++++--
 fs/proc/proc_misc.c                   |    4 
 fs/seq_file.c                         |   36 ++++++-
 fs/timerfd.c                          |   12 +-
 include/asm-mips/compat.h             |    7 +
 include/asm-mips/seccomp.h            |    1 
 include/asm-x86/mmzone_32.h           |    2 
 include/asm-x86/mmzone_64.h           |    2 
 include/asm-x86/seccomp_32.h          |    6 -
 include/asm-x86/seccomp_64.h          |    8 -
 include/linux/fs.h                    |   29 +++--
 include/linux/jbd2.h                  |    3 
 include/linux/mm.h                    |   19 +++
 include/linux/mmzone.h                |    2 
 include/linux/pci_ids.h               |    4 
 include/linux/seq_file.h              |    1 
 include/linux/serial_core.h           |    1 
 include/linux/skbuff.h                |    9 -
 include/linux/timerfd.h               |   16 ++-
 include/net/sock.h                    |    1 
 kernel/fork.c                         |   11 +-
 kernel/seccomp.c                      |    7 -
 kernel/tsacct.c                       |    6 +
 mm/page_alloc.c                       |   27 +++++
 net/bridge/br_netfilter.c             |   13 ++
 net/core/skbuff.c                     |    8 -
 net/core/sock.c                       |    3 
 security/selinux/netlabel.c           |    9 +
 sound/core/oss/rate.c                 |    2 
 sound/pci/aw2/aw2-alsa.c              |    2 
 sound/pci/hda/patch_realtek.c         |    1 
 sound/pci/oxygen/virtuoso.c           |   22 +---
 sound/usb/usbaudio.c                  |   20 ++--
 sound/usb/usbmidi.c                   |    1 
 120 files changed, 854 insertions(+), 411 deletions(-)

Adam Lackorzynski (1):
      jsm: additional device support

Alan Stern (2):
      USB: usb_get_string should check the descriptor type
      USB: usb-storage: add IGNORE_RESIDUE flag for Genesys Logic adapters

Alex Chiang (1):
      PCIe: portdrv: call pci_disable_device during remove

Alexander Duyck (1):
      PCI: Add PCI quirk to disable L0s ASPM state for 82575 and 82598

Alexander Graf (1):
      Fix no_timer_check on x86_64

Alexey Dobriyan (1):
      WATCHDOG: ks8695_wdt.c: 'CLOCK_TICK_RATE' undeclared

Alok N Kataria (1):
      x86, vmi: TSC going backwards check in vmi clocksource

Andrew Patterson (1):
      PCI: Enable PCIe AER only after checking firmware support

Aneesh Kumar K.V (2):
      ext4: Fix lockdep warning
      ext4: Initialize preallocation list_head's properly

Anssi Hannula (1):
      ALSA: aw2: do not grab every saa7146 based device

Ben Dooks (1):
      mmc: s3cmci: fix s3c2410_dma_config() arguments.

Bill Nottingham (1):
      vt: Declare PIO_CMAP/GIO_CMAP as compatbile ioctls.

Bjørn Mork (1):
      cdc_ether: add usb id for Ericsson F3507g

Christoph Hellwig (1):
      documnt FMODE_ constants

Clemens Ladisch (2):
      sound: usb-audio: fix uninitialized variable with M-Audio MIDI interfaces
      sound: virtuoso: revert "do not overwrite EEPROM on Xonar D2/D2X"

Dan Carpenter (1):
      ext4: Fix NULL dereference in ext4_ext_migrate()'s error handling

David Altobelli (1):
      hpilo: new pci device

David S. Miller (3):
      net: Kill skb_truesize_check(), it only catches false-positives.
      sparc64: Fix DAX handling via userspace access from kernel.
      sparc: We need to implement arch_ptrace_stop().

Davide Libenzi (1):
      timerfd: add flags check

Devin Heitmueller (1):
      DVB: s5h1409: Perform s5h1409 soft reset after tuning

Dmitriy Taychenachev (2):
      USB: cdc-acm: add usb id for motomagx phones
      zaurus: add usb id for motomagx phones

Ed L. Cashin (1):
      aoe: ignore vendor extension AoE responses

Eric Biederman (1):
      seq_file: properly cope with pread

Eugene Teo (1):
      net: amend the fix for SO_BSDCOMPAT gsopt infoleak

Faisal Latif (1):
      RDMA/nes: Don't allow userspace QPs to use STag zero

Francois Romieu (1):
      sis190: add identifier for Atheros AR8021 PHY

Greg Kroah-Hartman (2):
      asix: new device ids
      Linux 2.6.27.20

Hans Verkuil (1):
      V4L: ivtv: fix decoder crash regression

Heiko Carstens (1):
      Fix fixpoint divide exception in acct_update_integrals

Helge Bahmann (1):
      proc: fix PG_locked reporting in /proc/kpageflags

Helmut Schaa (1):
      sdhci: fix led naming

Henrique de Moraes Holschuh (1):
      ACPI: fix broken usage of name.ascii

Herbert Xu (1):
      bridge: netfilter: fix update_pmtu crash with GRE

HighPoint Linux Team (1):
      SCSI: hptiop: Add new PCI device ID

Ingo Molnar (2):
      inotify: fix GFP_KERNEL related deadlock
      x86: tone down mtrr_trim_uncached_memory() warning

Jan Kara (4):
      jbd2: Fix return value of jbd2_journal_start_commit()
      Revert "ext4: wait on all pending commits in ext4_sync_fs()"
      jbd2: Avoid possible NULL dereference in jbd2_journal_begin_ordered_truncate()
      ext4: Fix deadlock in ext4_write_begin() and ext4_da_write_begin()

Jason Cooper (1):
      USB: net: asix: add support for Cables-to-Go USB Ethernet adapter

Jean Delvare (2):
      hwmon: (f71882fg) Hide misleading error message
      hwmon: (it87) Properly decode -128 degrees C temperature

Jens Axboe (1):
      xen/blkfront: use blk_rq_map_sg to generate ring entries

Jeremy Fitzhardinge (1):
      xen: disable interrupts early, as start_kernel expects

Jesse Sung (1):
      USB: option: add BenQ 3g modem information

Joris van Rantwijk (1):
      ALSA: usb-audio - Workaround for misdetected sample rate with CM6207

KAMEZAWA Hiroyuki (2):
      mm: clean up for early_pfn_to_nid()
      mm: fix memmap init for handling memory hole

Karsten Wiese (1):
      USB: EHCI: slow down ITD reuse

Larry Finger (1):
      rtl8187: New USB ID's for RTL8187L

Leann Ogasawara (1):
      x86: add Dell XPS710 reboot quirk

Lubomir Rintel (1):
      intel-agp: fix a panic with 1M of shared memory, no GTT entries

Luke Yelavich (1):
      ALSA: hda - add another MacBook Pro 3,1 SSID

Mauro Carvalho Chehab (1):
      8250: fix boot hang with serial console when using with Serial Over Lan port

Meelis Roos (1):
      fore200: fix oops on failed firmware load

Michael Krufky (1):
      V4L: tda8290: fix TDA8290 + TDA18271 initialization

Michael Neuling (1):
      powerpc: Fix load/store float double alignment handler

NeilBrown (3):
      md: avoid races when stopping resync.
      md/raid10: Don't call bitmap_cond_end_sync when we are doing recovery.
      md/raid10: Don't skip more than 1 bitmap-chunk at a time during recovery.

Nick Piggin (1):
      fs: new inode i_state corruption fix

Oleg Nesterov (1):
      copy_process: fix CLONE_PARENT && parent_exec_id interaction

Paul Moore (2):
      selinux: Fix a panic in selinux_netlbl_inode_permission()
      selinux: Fix the NetLabel glue code for setsockopt()

Paul Turner (1):
      vfs: separate FMODE_PREAD/FMODE_PWRITE into separate flags

Phil Sutter (2):
      WATCHDOG: rc32434_wdt: fix watchdog driver
      WATCHDOG: rc32434_wdt: fix sections

Rabin Vincent (1):
      mmc_test: fix basic read test

Ralf Baechle (1):
      MIPS: compat: Implement is_compat_task.

Robert Hancock (1):
      libata: Don't trust current capacity values in identify words 57-58

Roel Kluin (2):
      i2c: Fix misplaced parentheses
      i2c: Timeouts reach -1

Roland McGrath (3):
      x86-64: fix int $0x80 -ENOSYS return
      x86-64: seccomp: fix 32/64 syscall hole
      x86-64: syscall-audit: fix 32/64 syscall hole

Russell King (1):
      ARM: Add i2c_board_info for RiscPC PCF8583

Sergei Shtylyov (1):
      ide-iops: fix odd-length ATAPI PIO transfers

Steve Chen (1):
      ALSA: fix excessive background noise introduced by OSS emulation rate shrink

Steve French (1):
      Fix oops in cifs_strfromUCS_le mounting to servers which do not specify their OS

Takashi Iwai (1):
      ALSA: usb-audio - Fix non-continuous rate detection

Tejun Heo (2):
      SCSI: sd: revive sd_index_lock
      libata: make sure port is thawed when skipping resets

Theodore Ts'o (1):
      ext4: Add fallback for find_group_flex

Thomas Gleixner (1):
      JFFS2: fix mount crash caused by removed nodes

Wei Yongjun (1):
      ext4: Fix to read empty directory blocks correctly in 64k

Will Newton (1):
      mtd_dataflash: fix probing of AT45DB321C chips.

Wu Fengguang (1):
      proc: fix kflags to uflags copying in /proc/kpageflags

Yinghai Lu (1):
      PCI quirk: enable MSI on 8132

