Return-Path: <linux-kernel-owner+w=401wt.eu-S932184Ab0AVXdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab0AVXdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 18:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932166Ab0AVXdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 18:33:47 -0500
Received: from kroah.org ([198.145.64.141]:41074 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164Ab0AVXdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 18:33:44 -0500
Date: Fri, 22 Jan 2010 15:32:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.5
Message-ID: <20100122233226.GA6092@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.5 kernel.  All users of the
2.6.32 kernel series are very strongly encouraged to upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 -
 arch/powerpc/kernel/pci-common.c         |   13 +++++++++
 arch/sparc/kernel/nmi.c                  |    3 +-
 arch/sparc/kernel/perf_event.c           |   11 +++++++
 arch/x86/kernel/apic/apic_flat_64.c      |    5 +++
 arch/x86/kernel/apic/x2apic_uv_x.c       |   15 +++++-----
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    5 ++-
 drivers/edac/i5000_edac.c                |    8 +++++
 drivers/gpu/drm/i915/i915_irq.c          |   43 ++++++++++++-------------------
 drivers/hid/hid-apple.c                  |    7 +++++
 drivers/hid/hid-core.c                   |    3 ++
 drivers/hid/hid-ids.h                    |    3 ++
 drivers/i2c/busses/i2c-pca-isa.c         |    4 +-
 drivers/i2c/busses/i2c-pca-platform.c    |    4 +-
 drivers/i2c/i2c-core.c                   |    5 ++-
 drivers/input/mouse/psmouse-base.c       |   28 ++++++++++----------
 drivers/media/video/gspca/sn9c20x.c      |    2 -
 drivers/mfd/wm8350-core.c                |    3 --
 drivers/pci/pci.c                        |    5 +++
 drivers/pcmcia/cardbus.c                 |    2 -
 drivers/platform/x86/asus-laptop.c       |    8 +++++
 drivers/scsi/megaraid/megaraid_sas.c     |    2 -
 drivers/serial/8250_pnp.c                |    2 +
 drivers/video/s3c-fb.c                   |   14 +++++-----
 fs/notify/inotify/inotify_fsnotify.c     |    2 -
 fs/notify/inotify/inotify_user.c         |    4 +-
 fs/reiserfs/inode.c                      |   17 ++++++++++--
 include/linux/blkdev.h                   |   11 ++++++-
 include/linux/mfd/wm8350/pmic.h          |   28 ++++++++++----------
 include/linux/pci.h                      |    3 ++
 kernel/futex.c                           |   27 ++++++++-----------
 kernel/sched.c                           |    6 ----
 kernel/sched_clock.c                     |   23 ++++++++++------
 mm/memcontrol.c                          |   11 ++-----
 mm/page_alloc.c                          |    2 -
 mm/truncate.c                            |   30 ++++++++++-----------
 sound/pci/hda/patch_realtek.c            |    2 +
 37 files changed, 221 insertions(+), 142 deletions(-)

Benjamin Herrenschmidt (1):
      PCI/cardbus: Add a fixup hook and fix powerpc

Bryn M. Reeves (1):
      megaraid_sas: remove sysfs poll_mode_io world writeable permissions

Christian Schuerer-Waldheim (1):
      HID: add device IDs for new model of Apple Wireless Keyboard

Cyrill Gorcunov (1):
      x86, mce: Thermal monitoring depends on APIC being enabled

Daisuke Nishimura (1):
      memcg: ensure list is empty at rmdir

David Miller (1):
      sched: Fix cpu_clock() in NMIs, on !CONFIG_HAVE_UNSTABLE_SCHED_CLOCK

David S. Miller (2):
      sparc64: Fix NMI programming when perf events are active.
      sparc64: Fix Niagara2 perf event handling.

Eric Paris (2):
      inotify: do not reuse watch descriptors
      inotify: only warn once for inotify problems

Greg Kroah-Hartman (1):
      Linux 2.6.32.5

Ike Panhc (1):
      asus-laptop: add Lenovo SL hotkey support

Jan Kara (1):
      reiserfs: truncate blocks not used by a write

KOSAKI Motohiro (2):
      futexes: Remove rw parameter from get_futex_key()
      page allocator: update NR_FREE_PAGES only when necessary

Mark Brown (3):
      revert "drivers/video/s3c-fb.c: fix clock setting for Samsung SoC Framebuffer"
      mfd: WM835x GPIO direction register is not locked
      mfd: Correct WM835x ISINK ramp time defines

Martin K. Petersen (1):
      block: Fix incorrect reporting of partition alignment

Mike Travis (1):
      x86: SGI UV: Fix mapping of MMIO registers

OGAWA Hirofumi (1):
      vfs: Fix vmtruncate() regression

Peter Zijlstra (1):
      sched: Fix task priority bug

Ping (1):
      serial/8250_pnp: add a new Fujitsu Wacom Tablet PC device

Roel Kluin (1):
      V4L/DVB (13868): gspca - sn9c20x: Fix test of unsigned.

Suresh Siddha (1):
      x86, apic: use physical mode for IBM summit platforms

Tai-hwa Liang (1):
      Input: pmouse - move Sentelic probe down the list

Takashi Iwai (1):
      ALSA: hda - Fix missing capture mixer for ALC861/660 codecs

Tamas Vincze (1):
      edac: i5000_edac critical fix panic out of bounds

Thadeu Lima de Souza Cascardo (1):
      i2c: Do not use device name after device_unregister

Wolfram Sang (1):
      i2c/pca: Don't use *_interruptible

Zou Nan hai (1):
      drm/i915: remove loop in Ironlake interrupt handler

