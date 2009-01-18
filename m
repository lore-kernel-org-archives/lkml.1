Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbZARS4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbZARS4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 13:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbZARSzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 13:55:44 -0500
Received: from kroah.org ([198.145.64.141]:49727 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752614AbZARSz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 13:55:27 -0500
Date: Sun, 18 Jan 2009 10:54:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.28.1
Message-ID: <20090118185408.GC6478@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.28.1
kernel.

It contains a wide range of bugfixes, and all users of the 2.6.28 kernel
series are strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.28 and 2.6.28.1

The updated 2.6.28.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.28.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.28.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                   |    2 
 arch/Kconfig                               |    3 
 arch/alpha/kernel/entry.S                  |    8 -
 arch/alpha/kernel/systbls.S                |    2 
 arch/arm/kernel/calls.S                    |    2 
 arch/cris/arch-v10/kernel/entry.S          |    2 
 arch/cris/arch-v32/kernel/entry.S          |    2 
 arch/h8300/kernel/syscalls.S               |    2 
 arch/ia64/ia32/ia32_entry.S                |    2 
 arch/ia64/include/asm/unistd.h             |    2 
 arch/ia64/kernel/entry.S                   |    2 
 arch/ia64/kernel/sys_ia64.c                |    2 
 arch/m68k/kernel/entry.S                   |    2 
 arch/m68knommu/kernel/syscalltable.S       |    2 
 arch/mips/kernel/scall32-o32.S             |    2 
 arch/mn10300/kernel/entry.S                |    2 
 arch/powerpc/Kconfig                       |    1 
 arch/powerpc/include/asm/systbl.h          |    2 
 arch/powerpc/platforms/pseries/Kconfig     |    2 
 arch/s390/Kconfig                          |    1 
 arch/s390/kernel/compat_wrapper.S          |    4 
 arch/s390/kernel/entry.h                   |   16 +-
 arch/s390/kernel/process.c                 |    9 -
 arch/s390/kernel/signal.c                  |   19 +--
 arch/s390/kernel/sys_s390.c                |   35 +++--
 arch/s390/kernel/syscalls.S                |   12 +-
 arch/sh/include/asm/syscalls_32.h          |    6 -
 arch/sh/kernel/sys_sh32.c                  |    2 
 arch/sh/kernel/syscalls_32.S               |    4 
 arch/sh/kernel/syscalls_64.S               |    2 
 arch/sparc/kernel/entry.S                  |    4 
 arch/sparc/kernel/systbls.S                |    4 
 arch/sparc64/kernel/syscalls.S             |    2 
 arch/sparc64/kernel/systbls.S              |    4 
 arch/x86/Kconfig                           |    2 
 arch/x86/kernel/cpu/addon_cpuid_features.c |    8 +
 arch/x86/kernel/cpu/intel.c                |    8 +
 arch/x86/kernel/head64.c                   |    2 
 arch/x86/kernel/head_64.S                  |    2 
 arch/x86/kernel/syscall_table_32.S         |    2 
 arch/x86/kernel/tlb_uv.c                   |    9 -
 arch/x86/mm/fault.c                        |    2 
 drivers/dma/ioat_dma.c                     |   13 +-
 drivers/hid/hid-sony.c                     |    2 
 drivers/ide/tx4938ide.c                    |    4 
 drivers/ide/tx4939ide.c                    |   10 +
 drivers/md/bitmap.c                        |    8 -
 drivers/md/dm-log.c                        |    5 
 drivers/md/dm-raid1.c                      |    6 -
 drivers/net/wireless/ath5k/phy.c           |    4 
 drivers/net/wireless/ath5k/reset.c         |    4 
 drivers/net/wireless/ath9k/recv.c          |    5 
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   12 --
 drivers/net/wireless/iwlwifi/iwl-rx.c      |   29 +++-
 drivers/pci/syscall.c                      |   12 --
 drivers/scsi/eata.c                        |   15 ++
 drivers/scsi/ibmvscsi/ibmvfc.c             |   25 ++--
 drivers/scsi/ibmvscsi/ibmvfc.h             |    6 -
 drivers/scsi/mvsas.c                       |    2 
 drivers/scsi/pcmcia/aha152x_stub.c         |    2 
 drivers/usb/host/isp1760-if.c              |  113 +++++++++++--------
 drivers/usb/misc/emi26.c                   |    2 
 drivers/usb/storage/unusual_devs.h         |   23 +++
 fs/affs/file.c                             |    2 
 fs/afs/write.c                             |    2 
 fs/aio.c                                   |   22 +--
 fs/buffer.c                                |    6 -
 fs/cifs/cifs_dfs_ref.c                     |   48 ++++++--
 fs/cifs/file.c                             |    2 
 fs/compat.c                                |    6 -
 fs/dcache.c                                |    7 -
 fs/dcookies.c                              |   10 +
 fs/ecryptfs/inode.c                        |    3 
 fs/ecryptfs/mmap.c                         |    2 
 fs/eventfd.c                               |    5 
 fs/eventpoll.c                             |   18 +--
 fs/exec.c                                  |    2 
 fs/ext3/inode.c                            |    2 
 fs/ext3/namei.c                            |    3 
 fs/ext4/inode.c                            |    4 
 fs/ext4/namei.c                            |    3 
 fs/fcntl.c                                 |   11 +
 fs/filesystems.c                           |    2 
 fs/fuse/file.c                             |    4 
 fs/gfs2/ops_address.c                      |    2 
 fs/hostfs/hostfs_kern.c                    |    2 
 fs/inotify_user.c                          |    9 -
 fs/ioctl.c                                 |    2 
 fs/ioprio.c                                |    5 
 fs/jffs2/file.c                            |    2 
 fs/libfs.c                                 |    2 
 fs/locks.c                                 |    2 
 fs/minix/dir.c                             |    2 
 fs/namei.c                                 |   48 ++++----
 fs/namespace.c                             |   13 +-
 fs/nfs/file.c                              |    2 
 fs/nfs/read.c                              |    6 -
 fs/nfsctl.c                                |    4 
 fs/open.c                                  |   82 ++++++++-----
 fs/pipe.c                                  |    4 
 fs/quota.c                                 |    3 
 fs/read_write.c                            |   49 +++++---
 fs/readdir.c                               |    9 +
 fs/reiserfs/inode.c                        |    2 
 fs/select.c                                |   29 ++--
 fs/signalfd.c                              |    8 -
 fs/smbfs/file.c                            |    2 
 fs/splice.c                                |   12 +-
 fs/stat.c                                  |   38 +++---
 fs/super.c                                 |    2 
 fs/sync.c                                  |   32 ++++-
 fs/timerfd.c                               |   10 -
 fs/ubifs/file.c                            |    9 -
 fs/utimes.c                                |   11 +
 fs/xattr.c                                 |   53 ++++----
 fs/xfs/xfs_dir2_block.c                    |    7 -
 fs/xfs/xfs_dir2_leaf.c                     |    6 -
 fs/xfs/xfs_dir2_sf.c                       |   15 +-
 include/linux/compat.h                     |   13 ++
 include/linux/fs.h                         |    5 
 include/linux/mm.h                         |    1 
 include/linux/pagemap.h                    |    3 
 include/linux/radix-tree.h                 |    2 
 include/linux/syscalls.h                   |  171 ++++++++++++++++++++---------
 include/linux/time.h                       |    1 
 ipc/mqueue.c                               |   28 ++--
 ipc/msg.c                                  |   12 +-
 ipc/sem.c                                  |   18 ++-
 ipc/shm.c                                  |    8 -
 kernel/acct.c                              |    2 
 kernel/capability.c                        |    4 
 kernel/cgroup.c                            |    6 -
 kernel/exec_domain.c                       |    3 
 kernel/exit.c                              |   17 +-
 kernel/fork.c                              |    4 
 kernel/futex.c                             |   17 +-
 kernel/hrtimer.c                           |    4 
 kernel/itimer.c                            |    7 -
 kernel/kexec.c                             |    5 
 kernel/module.c                            |   10 -
 kernel/posix-timers.c                      |   43 +++----
 kernel/printk.c                            |    7 -
 kernel/ptrace.c                            |    2 
 kernel/sched.c                             |   30 ++---
 kernel/sched_clock.c                       |    5 
 kernel/signal.c                            |   59 ++++------
 kernel/sys.c                               |   72 ++++++------
 kernel/sys_ni.c                            |    1 
 kernel/sysctl.c                            |    4 
 kernel/time.c                              |   14 +-
 kernel/time/timekeeping.c                  |    7 -
 kernel/timer.c                             |   18 +--
 kernel/trace/ring_buffer.c                 |   19 ++-
 kernel/uid16.c                             |   39 +++---
 mm/fadvise.c                               |   18 ++-
 mm/filemap.c                               |   22 ++-
 mm/fremap.c                                |    4 
 mm/madvise.c                               |    2 
 mm/mempolicy.c                             |   24 +---
 mm/migrate.c                               |    8 -
 mm/mincore.c                               |    4 
 mm/mlock.c                                 |    8 -
 mm/mmap.c                                  |    4 
 mm/mprotect.c                              |    4 
 mm/mremap.c                                |    6 -
 mm/msync.c                                 |    2 
 mm/nommu.c                                 |   10 -
 mm/swapfile.c                              |    4 
 mm/vmalloc.c                               |    5 
 net/socket.c                               |   63 +++++-----
 security/device_cgroup.c                   |    3 
 security/keys/keyctl.c                     |   22 +--
 sound/pci/hda/patch_analog.c               |    5 
 sound/pci/hda/patch_sigmatel.c             |    2 
 sound/usb/caiaq/caiaq-device.h             |    1 
 sound/usb/caiaq/caiaq-midi.c               |   32 +++--
 176 files changed, 1182 insertions(+), 885 deletions(-)

Adam Lackorzynski (1):
      vmalloc.c: fix flushing in vmap_page_range()

Al Viro (1):
      fix switch_names() breakage in short-to-short case

Andi Kleen (1):
      x86: avoid theoretical vmalloc fault loop

Atsushi Nemoto (2):
      tx493[89]ide: Fix length for __ide_flush_dcache_range
      tx4939ide: Do not use zero count PRD entry

Benjamin Herrenschmidt (1):
      powerpc: Enable syscall wrappers for 64-bit

Bernd Schmidt (1):
      Fix timeouts in sys_pselect7

Brian King (3):
      powerpc: Disable Collaborative Memory Manager for kdump
      ibmvfc: Delay NPIV login retry and add retries
      ibmvfc: Improve async event handling

Christoph Hellwig (1):
      XFS: truncate readdir offsets to signed 32 bit values

Clemens Fruhwirth (1):
      ALSA: hda - Fix typos for AD1882 codecs

Cliff Wickman (1):
      x86, UV: remove erroneous BAU initialization

Dan Williams (1):
      ioat: fix self test for multi-channel case

Daniel Drake (1):
      USB: unusual_devs.h additions for Pentax K10D

Duane Griffin (1):
      eCryptfs: check readlink result was not an error before using it

Evgeniy Dushistov (1):
      minix: fix add link's wrong position calculation

FUJITA Tomonori (1):
      SCSI: eata: fix the data buffer accessors conversion regression

Felix Fietkau (1):
      ath5k: ignore the return value of ath5k_hw_noise_floor_calibration

Greg Kroah-Hartman (1):
      Linux 2.6.28.1

Heiko Carstens (43):
      Move compat system call declarations to compat header file
      Convert all system calls to return a long
      Rename old_readdir to sys_old_readdir
      Remove __attribute__((weak)) from sys_pipe/sys_pipe2
      Make sys_pselect7 static
      Make sys_syslog a conditional system call
      System call wrapper infrastructure
      s390: enable system call wrappers
      System call wrapper special cases
      System call wrappers part 01
      System call wrappers part 02
      System call wrappers part 03
      System call wrappers part 04
      System call wrappers part 05
      System call wrappers part 06
      System call wrappers part 07
      System call wrappers part 08
      System call wrappers part 09
      System call wrappers part 10
      System call wrappers part 11
      System call wrappers part 12
      System call wrappers part 13
      System call wrappers part 14
      System call wrappers part 15
      System call wrappers part 16
      System call wrappers part 17
      System call wrappers part 18
      System call wrappers part 19
      System call wrappers part 20
      System call wrappers part 21
      System call wrappers part 22
      System call wrappers part 23
      System call wrappers part 24
      System call wrappers part 25
      System call wrappers part 26
      System call wrappers part 27
      System call wrappers part 28
      System call wrappers part 29
      System call wrappers part 30
      System call wrappers part 31
      System call wrappers part 32
      System call wrappers part 33
      s390 specific system call wrappers

Jiri Kosina (1):
      HID: fix error condition propagation in hid-sony driver

Jiri Slaby (1):
      x86: fix RIP printout in early_idt_handler

Joerg Roedel (1):
      x86: default to SWIOTLB=y on x86_64

Jonathan Brassow (1):
      dm raid1: fix error count

KOSAKI Motohiro (1):
      getrusage: RUSAGE_THREAD should return ru_utime and ru_stime

Karl Bongers (1):
      USB: isp1760: Fix probe in PCI glue code

Larry Finger (1):
      SCSI: aha152x_cs: Fix regression that keeps driver from using shared interrupts

Li Zefan (1):
      cgroups: fix a race between cgroup_clone and umount

Luis R. Rodriguez (1):
      ath9k: enable RXing of beacons on STA/IBSS

Marcin Slusarz (1):
      USB: emi26: fix oops on load

Michael Kerrisk (1):
      inotify: fix type errors in interfaces

NeilBrown (1):
      md: fix bitmap-on-external-file bug.

Nguyen Anh Quynh (1):
      USB: another unusual_devs entry for another bad Argosy storage device

Nick Piggin (3):
      fs: symlink write_begin allocation context fix
      mm lockless pagecache barrier fix
      mm: fix assertion

Oliver Neukum (1):
      USB: storage: extend unusual range for 067b:3507

Paulo Afonso Graner Fessel (1):
      USB: storage: recognizing and enabling Nokia 5200 cell phoes

Ravikiran G Thirumalai (1):
      x86: fix incorrect __read_mostly on _boot_cpu_pda

Reinhard Nissl (1):
      mvsas: increase port type detection delay to suit Seagate's 10k6 drive ST3450856SS 0003

Sebastian Andrzej Siewior (1):
      USB: isp1760: use a specific PLX bridge instead of any bdridge

Serge E. Hallyn (1):
      devices cgroup: allow mkfifo

Steve French (1):
      CIFS: make sure that DFS pathnames are properly formed

Steven Rostedt (2):
      ring-buffer: prevent false positive warning
      ring-buffer: fix dangling commit race

Suresh Siddha (1):
      x86: fix intel x86_64 llc_shared_map/cpu_llc_id anomolies

Takahiro Yasui (1):
      dm log: fix dm_io_client leak on error paths

Takashi Iwai (3):
      ALSA: hda - Add quirk for another HP dv7
      ALSA: hda - Add quirk for HP6730B laptop
      ALSA: caiaq - Fix Oops with MIDI

Thomas Gleixner (1):
      sched_clock: prevent scd->clock from moving backwards, take #2

Wu Fengguang (1):
      nfs: remove redundant tests on reading new pages

Zhu Yi (1):
      iwlwifi: use GFP_KERNEL to allocate Rx SKB memory

