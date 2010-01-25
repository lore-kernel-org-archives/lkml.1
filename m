Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740Ab0AYS5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab0AYS5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 13:57:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616Ab0AYS5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 13:57:09 -0500
Received: from kroah.org ([198.145.64.141]:33554 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045Ab0AYS5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 13:57:09 -0500
Date: Mon, 25 Jan 2010 10:56:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.6
Message-ID: <20100125185601.GA20555@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.6 kernel.  All users of the
2.6.32 kernel series are very strongly encouraged to upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                              |    2 
 arch/x86/kernel/cpuid.c               |    5 -
 arch/x86/kernel/msr.c                 |    4 -
 arch/x86/pci/i386.c                   |    9 ++
 block/blk-settings.c                  |   22 +++++
 drivers/acpi/ec.c                     |  125 +++++++++++++++++++++-------------
 drivers/char/nozomi.c                 |    2 
 drivers/char/tty_io.c                 |    2 
 drivers/gpu/drm/i915/intel_sdvo.c     |   83 +++++++++++++++++++++-
 drivers/md/dm-table.c                 |   20 +----
 drivers/media/video/gspca/sunplus.c   |   26 +++----
 drivers/misc/enclosure.c              |    1 
 drivers/serial/8250_pnp.c             |   10 --
 drivers/staging/asus_oled/asus_oled.c |   12 ++-
 drivers/staging/hv/Hv.c               |   50 ++++++-------
 drivers/staging/hv/Hv.h               |    6 -
 drivers/staging/hv/Vmbus.c            |   12 +--
 drivers/usb/core/devices.c            |    2 
 drivers/usb/core/hub.c                |    3 
 drivers/usb/core/message.c            |    8 +-
 drivers/usb/core/sysfs.c              |    6 +
 drivers/usb/host/ehci-hcd.c           |    5 -
 drivers/usb/host/ehci-hub.c           |   20 +++++
 drivers/usb/host/ehci-q.c             |   11 ++
 drivers/usb/host/uhci-hcd.c           |   15 +++-
 drivers/usb/host/uhci-hub.c           |    2 
 drivers/usb/serial/generic.c          |    2 
 drivers/usb/storage/unusual_devs.h    |    7 -
 drivers/usb/storage/usb.c             |    3 
 fs/ecryptfs/crypto.c                  |    4 -
 fs/ecryptfs/file.c                    |   14 +--
 include/linux/blkdev.h                |    2 
 include/linux/enclosure.h             |    2 
 kernel/perf_event.c                   |   30 +++++++-
 mm/vmalloc.c                          |    4 -
 tools/perf/builtin-timechart.c        |    2 
 36 files changed, 365 insertions(+), 168 deletions(-)

Alan Cox (1):
      nozomi: quick fix for the close/close bug

Alan Stern (4):
      USB: fix bitmask merge error
      USB: EHCI: fix handling of unusual interrupt intervals
      USB: EHCI & UHCI: fix race between root-hub suspend and port resume
      USB: add missing delay during remote wakeup

Alexey Starikovskiy (2):
      ACPI: EC: Accelerate query execution
      ACPI: EC: Add wait for irq storm

Arjan van de Ven (1):
      perf timechart: Use tid not pid for COMM change

Dan Carpenter (1):
      ecryptfs: use after free

Erez Zadok (1):
      ecryptfs: initialize private persistent file before dereferencing pointer

Eugeni Dodonov (1):
      Staging: asus_oled: fix oops in 2.6.32.2

Greg Kroah-Hartman (4):
      Staging: hv: fix smp problems in the hyperv core code
      tty: fix race in tty_fasync
      USB: add speed values for USB 3.0 and wireless controllers
      Linux 2.6.32.6

H. Peter Anvin (1):
      x86, msr/cpuid: Register enough minors for the MSR and CPUID drivers

James Bottomley (1):
      SCSI: enclosure: fix oops while iterating enclosure_status array

Jean-Francois Moine (1):
      V4L/DVB (13900): gspca - sunplus: Fix bridge exchanges.

Johan Hovold (1):
      usb: serial: fix memory leak in generic driver

Martin K. Petersen (2):
      block: bdev_stack_limits wrapper
      DM: Fix device mapper topology stacking

Matthew Garrett (1):
      serial: 8250_pnp: use wildcard for serial Wacom tablets

Oliver Neukum (1):
      USB: Don't use GFP_KERNEL while we cannot reset a storage device

Peter Zijlstra (2):
      perf events: Dont report side-band events on each cpu for per-task-per-cpu events
      perf: Honour event state for aux stream data

Ryan May (1):
      USB: fix usbstorage for 2770:915d delivers no FAT

Suresh Siddha (1):
      x86/PCI/PAT: return EINVAL for pci mmap WC request for !pat_enabled

Yongseok Koh (1):
      vmalloc: remove BUG_ON due to racy counting of VM_LAZY_FREE

Zhao Yakui (2):
      drm/i915: Read the response after issuing DDC bus switch command
      drm/i915: try another possible DDC bus for the SDVO device with multiple outputs

