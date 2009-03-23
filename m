Return-Path: <linux-kernel-owner+w=401wt.eu-S1760024AbZCWWNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024AbZCWWNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 18:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbZCWWNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 18:13:07 -0400
Received: from kroah.org ([198.145.64.141]:41578 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751467AbZCWWNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 18:13:05 -0400
Date: Mon, 23 Mar 2009 15:09:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.28.9
Message-ID: <20090323220927.GA11563@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.28.9 kernel.

It contains a wide range of bugfixes, and all users of the 2.6.28 kernel
series are strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.28.8 and 2.6.28.9

The updated 2.6.28.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.28.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.28.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    5 ++-
 arch/ia64/Kconfig                           |    3 -
 arch/powerpc/sysdev/fsl_soc.c               |    2 -
 arch/s390/lib/div64.c                       |    2 -
 arch/x86/include/asm/msr-index.h            |   29 ++++++++++++++++++
 arch/x86/kernel/cpu/intel.c                 |   13 ++++++++
 drivers/ata/ata_piix.c                      |   37 ++++++++++++++++++++++++
 drivers/gpu/drm/drm_irq.c                   |   18 +++++++++--
 drivers/gpu/drm/i915/i915_gem.c             |   20 ++++++++-----
 drivers/gpu/drm/i915/i915_irq.c             |    6 +++
 drivers/md/dm-crypt.c                       |   43 ++++++++++++++++++++--------
 drivers/md/dm-io.c                          |    2 +
 drivers/md/dm-ioctl.c                       |    3 +
 drivers/md/dm.c                             |   32 ++++++++++++--------
 drivers/media/video/cx23885/cx23885-417.c   |    3 +
 drivers/media/video/cx23885/cx23885-video.c |    5 +--
 drivers/misc/thinkpad_acpi.c                |    8 ++---
 drivers/usb/class/usbtmc.c                  |    4 +-
 drivers/usb/core/devio.c                    |   12 ++++---
 drivers/usb/host/ehci-q.c                   |    3 +
 drivers/usb/host/ehci-sched.c               |   10 ++----
 drivers/usb/serial/cp2101.c                 |    1 
 drivers/usb/serial/ftdi_sio.c               |    5 +++
 drivers/usb/serial/ftdi_sio.h               |   20 +++++++++++++
 drivers/usb/serial/option.c                 |   12 +++----
 drivers/usb/storage/unusual_devs.h          |   16 +++++++++-
 fs/aio.c                                    |   37 +++++++++++++++++-------
 fs/ecryptfs/crypto.c                        |   39 ++++++++++++++++---------
 fs/nfsd/nfs4xdr.c                           |    1 
 include/linux/capability.h                  |    6 ++-
 init/Kconfig                                |   30 +++++++++----------
 sound/core/oss/pcm_oss.c                    |    4 +-
 sound/core/sgbuf.c                          |    7 ++--
 sound/isa/opl3sa2.c                         |   18 +++++++----
 sound/pci/hda/hda_intel.c                   |   39 ++++++++++++++++---------
 sound/pci/mixart/mixart.c                   |    1 
 36 files changed, 363 insertions(+), 133 deletions(-)

Achilleas Kotsis (1):
      USB: Add device id for Option GTM380 to option driver

Alan Stern (2):
      USB: usbfs: keep async URBs until the device file is closed
      USB: EHCI: expedite unlinks when the root hub is suspended

Albert Pauw (1):
      USB: option.c: add ZTE 622 modem device

Andy Walls (1):
      V4L/DVB (10218): cx23885: Fix Oops for mixed install of analog and digital only cards

Axel Wachtler (1):
      USB: serial: add FTDI USB/Serial converter devices

Benny Halevy (1):
      NFSD: provide encode routine for OP_OPENATTR

Dan Williams (1):
      USB: Option: let cdc-acm handle Sony Ericsson F3507g / Dell 5530

Davide Libenzi (1):
      eventfd: remove fput() call from possible IRQ context

Dirk Hohndel (1):
      USB: Add Vendor/Product ID for new CDMA U727 to option driver

Eric Anholt (3):
      drm/i915: Don't double-unpin buffers if we take a signal in evict_everything().
      drm/i915: Don't print to dmesg when taking signal during object_pin.
      drm/i915: Don't allow objects to get bound while VT switched.

Greg Kroah-Hartman (3):
      USB: usbtmc: fix stupid bug in open()
      USB: usbtmc: add protocol 1 support
      Linux 2.6.28.9

Huang Ying (1):
      dm crypt: fix kcryptd_async_done parameter

J. Bruce Fields (1):
      nfsd: nfsd should drop CAP_MKNOD for non-root

Jan Dumon (1):
      USB: unusual_devs: Add support for GI 0431 SD-Card interface

Jesse Barnes (2):
      drm/i915: set vblank enabled flag correctly across IRQ install/uninstall
      drm/i915: don't enable vblanks on disabled pipes

Jiri Slaby (2):
      ALSA: mixart, fix lock imbalance
      ALSA: pcm_oss, fix locking typo

Joe Korty (1):
      Fix misreporting of #cores as #hyperthreads for Q9550

Johns Daniel (1):
      powerpc: Remove extra semicolon in fsl_soc.c

Karsten Wiese (1):
      USB: EHCI: Fix isochronous URB leak

Krzysztof Helt (1):
      ALSA: opl3sa2 - Fix NULL dereference when suspending snd_opl3sa2

Linus Torvalds (2):
      Add '-fwrapv' to gcc CFLAGS
      Move cc-option to below arch-specific setup

Martin Schwidefsky (1):
      S390: __div64_31 broken for CONFIG_MARCH_G5

Mathieu Chouquet-Stringer (1):
      thinkpad-acpi: fix module autoloading for older models

Michael Hennerich (1):
      USB: serial: ftdi: enable UART detection on gnICE JTAG adaptors blacklist interface0

Mikulas Patocka (1):
      dm io: respect BIO_MAX_PAGES limit

Milan Broz (2):
      dm ioctl: validate name length when renaming
      dm crypt: wait for endio to complete before destruction

Moritz Muehlenhoff (1):
      USB: Updated unusual-devs entry for USB mass storage on Nokia 6233

Randy Dunlap (1):
      menu: fix embedded menu snafu

Robert M. Kenney (1):
      USB: serial: new cp2101 device id

Takashi Iwai (3):
      ALSA: Fix vunmap and free order in snd_free_sgbuf_pages()
      ALSA: hda - Fix DMA mask for ATI controllers
      ALSA: hda - Workaround for buggy DMA position on ATI controllers

Tejun Heo (1):
      ata_piix: add workaround for Samsung DB-P70

Thomas Bartosik (1):
      USB: storage: Unusual USB device Prolific 2507 variation added

Tony Luck (1):
      Build fix for __early_pfn_to_nid() undefined link error

Tyler Hicks (1):
      eCryptfs: Allocate a variable number of pages for file headers

