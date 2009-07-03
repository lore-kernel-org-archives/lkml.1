Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbZGCAMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbZGCAMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757399AbZGCALn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:11:43 -0400
Received: from kroah.org ([198.145.64.141]:49690 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757304AbZGCALh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:11:37 -0400
Date: Thu, 2 Jul 2009 17:09:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.29.6
Message-ID: <20090703000927.GA27031@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

****NOTE****
This is the last release of the 2.6.29 kernel series.  All users are
strongly suggested to move to the 2.6.30 release series at this time.
************

I'm announcing the release of the 2.6.29.6 kernel.  All users of the
2.6.29 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.29.5 and 2.6.29.6

The updated 2.6.29.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.29.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                         |    2 
 arch/x86/kernel/cpu/amd.c        |    4 
 arch/x86/kernel/reboot.c         |    9 ++
 arch/x86/kernel/setup.c          |   15 ---
 drivers/block/floppy.c           |    8 +
 drivers/char/moxa.c              |    7 +
 drivers/char/mxser.c             |    2 
 drivers/char/pcmcia/cm4000_cs.c  |    3 
 drivers/char/vt_ioctl.c          |    3 
 drivers/firmware/memmap.c        |   16 ++-
 drivers/infiniband/hw/mlx4/qp.c  |    4 
 drivers/input/keyboard/atkbd.c   |  169 ++++++++++++++++++++++-----------------
 drivers/isdn/hisax/hfc_pci.c     |   41 ++++++---
 drivers/isdn/hisax/hisax.h       |    2 
 drivers/md/dm-mpath.c            |   11 ++
 drivers/md/dm.c                  |    4 
 drivers/md/raid5.c               |    1 
 drivers/net/bonding/bond_sysfs.c |    1 
 drivers/net/r8169.c              |   11 +-
 drivers/parport/parport_pc.c     |   34 ++++++-
 drivers/parport/parport_serial.c |   30 +++++-
 drivers/pci/pci.c                |    7 -
 drivers/pci/pcie/aspm.c          |    4 
 drivers/scsi/qla2xxx/qla_dbg.c   |    2 
 drivers/serial/8250.c            |   15 +++
 drivers/usb/class/usbtmc.c       |    6 +
 drivers/video/atmel_lcdfb.c      |   10 --
 fs/fs-writeback.c                |    2 
 fs/jbd/commit.c                  |    6 -
 include/linux/firmware-map.h     |   12 --
 include/linux/mlx4/qp.h          |    1 
 kernel/acct.c                    |    6 -
 lib/Kconfig.debug                |    2 
 mm/page_alloc.c                  |    6 -
 net/mac80211/rc80211_minstrel.c  |    2 
 sound/core/seq/seq_midi_event.c  |    8 -
 sound/pci/ca0106/ca0106_mixer.c  |    6 +
 37 files changed, 311 insertions(+), 161 deletions(-)


Alan Cox (1):
      8250: Fix oops from setserial

Andreas Herrmann (1):
      x86: Set cpu_llc_id on AMD CPUs

Andrew Vasquez (1):
      qla2xxx: Correct (again) overflow during dump-processing on large-memory ISP23xx parts.

Bob Copeland (1):
      mac80211: fix minstrel single-rate memory corruption

Chuck Ebbert (1):
      atkbd: add forced release quirks for four more keyboard models

Clemens Ladisch (1):
      sound: seq_midi_event: fix decoding of (N)RPN events

Dan Williams (1):
      md/raid5: add missing call to schedule() after prepare_to_wait()

Dimitri Sivanich (1):
      mm: fix handling of pagesets for downed cpus

Dirk Eibach (1):
      char: moxa, prevent opening unavailable ports

Eric Dumazet (1):
      r8169: fix crash when large packets are received

FUJITA Tomonori (1):
      parport_pc: set properly the dma_mask for parport_pc device

Greg Kroah-Hartman (2):
      USB: usbtmc: fix switch statment
      Linux 2.6.29.6

Jack Morgenstein (1):
      IB/mlx4: Add strong ordering to local inval and fast reg work requests

Jan Kara (1):
      jbd: fix race in buffer processing in commit code

Jean Delvare (1):
      x86: Add quirk for reboot stalls on a Dell Optiplex 360

Jens Rottmann (1):
      parport_pc: after superio probing restore original register values

Jiri Slaby (2):
      vt_ioctl: fix lock imbalance
      pcmcia/cm4000: fix lock imbalance

Karsten Keil (1):
      ISDN: Fix DMA alloc for hfcpci

Mikulas Patocka (2):
      dm mpath: validate table argument count
      dm mpath: validate hw_handler argument count

Milan Broz (1):
      dm: sysfs skip output when device is being destroyed

Nick Piggin (1):
      fs: remove incorrect I_NEW warnings

Nicolas Ferre (1):
      atmel_lcdfb: correct fifo size for some products

Peter Botha (1):
      char: mxser, fix ISA board lookup

Peter Zijlstra (1):
      lockdep: Select frame pointers on x86

Philippe De Muyter (1):
      parport: netmos 9845 & 9855 1P4S fixes

Rafael J. Wysocki (2):
      PCI PM: Fix handling of devices without PM support by pci_target_state()
      PCI PM: Follow PCI_PM_CTRL_NO_SOFT_RESET during transitions from D3

Renaud Lottiaux (1):
      bsdacct: fix access to invalid filp in acct_on()

Scott James Remnant (1):
      floppy: provide a PNP device table in the module.

Shaohua Li (1):
      PCI: disable ASPM on VIA root-port-under-bridge configurations

Stephen Hemminger (1):
      bonding: fix multiple module load problem

Takashi Iwai (1):
      ALSA: ca0106 - Add missing registrations of vmaster controls

Yinghai Lu (2):
      firmware_map: fix hang with x86/32bit
      x86: handle initrd that extends into unusable memory

