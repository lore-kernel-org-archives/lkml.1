Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbZGCALs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbZGCALs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbZGCALg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:11:36 -0400
Received: from kroah.org ([198.145.64.141]:49683 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324AbZGCALf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:11:35 -0400
Date: Thu, 2 Jul 2009 17:07:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.27.26
Message-ID: <20090703000703.GA17190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.26 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.25 and 2.6.27.26

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                         |    2 
 arch/x86/kernel/reboot.c         |   18 ++++++++
 arch/x86/kernel/setup.c          |   15 +-----
 drivers/block/floppy.c           |   87 ++++++++++++++++++++++++++-------------
 drivers/char/moxa.c              |    7 ++-
 drivers/char/mxser.c             |    2 
 drivers/char/pcmcia/cm4000_cs.c  |    3 -
 drivers/firmware/memmap.c        |   16 ++++---
 drivers/infiniband/hw/mlx4/qp.c  |    4 +
 drivers/isdn/hisax/hfc_pci.c     |   41 +++++++++++++-----
 drivers/isdn/hisax/hisax.h       |    2 
 drivers/md/dm-mpath.c            |   11 ++++
 drivers/md/dm.c                  |    4 +
 drivers/md/raid5.c               |    1 
 drivers/net/bonding/bond_sysfs.c |    1 
 drivers/net/r8169.c              |   11 ++--
 drivers/parport/parport_pc.c     |   34 ++++++++++++---
 drivers/parport/parport_serial.c |   30 +++++++++++--
 drivers/pci/pci.c                |    7 +--
 drivers/pci/pcie/aspm.c          |    4 +
 drivers/video/atmel_lcdfb.c      |   10 ----
 fs/jbd/commit.c                  |    6 +-
 include/linux/firmware-map.h     |   12 +----
 include/linux/mlx4/qp.h          |    1 
 kernel/acct.c                    |    6 +-
 lib/Kconfig.debug                |    2 
 mm/page_alloc.c                  |    6 +-
 net/ipv4/tcp_ipv4.c              |    4 +
 net/ipv4/tcp_output.c            |   13 ++++-
 scripts/unifdef.c                |    6 +-
 sound/core/seq/seq_midi_event.c  |    8 +--
 sound/pci/ca0106/ca0106_mixer.c  |    6 ++
 32 files changed, 265 insertions(+), 115 deletions(-)

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

Greg Kroah-Hartman (1):
      Linux 2.6.27.26

Jack Morgenstein (1):
      IB/mlx4: Add strong ordering to local inval and fast reg work requests

Jan Kara (1):
      jbd: fix race in buffer processing in commit code

Jean Delvare (1):
      x86: Add quirk for reboot stalls on a Dell Optiplex 360

Jens Rottmann (1):
      parport_pc: after superio probing restore original register values

Jiri Slaby (1):
      pcmcia/cm4000: fix lock imbalance

Justin P. Mattock (1):
      kbuild: fix C libary confusion in unifdef.c due to getline()

Karsten Keil (1):
      ISDN: Fix DMA alloc for hfcpci

Mikulas Patocka (2):
      dm mpath: validate hw_handler argument count
      dm mpath: validate table argument count

Milan Broz (1):
      dm: sysfs skip output when device is being destroyed

Nicolas Ferre (1):
      atmel_lcdfb: correct fifo size for some products

Peter Botha (1):
      char: mxser, fix ISA board lookup

Peter Zijlstra (1):
      lockdep: Select frame pointers on x86

Philippe De Muyter (2):
      parport: netmos 9845 & 9855 1P4S fixes
      floppy: request and release only the ports we actually use

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

Steve Conklin (1):
      x86: quirk for reboot stalls on a Dell Optiplex 330

Takashi Iwai (1):
      ALSA: ca0106 - Add missing registrations of vmaster controls

Tom Quetchenbach (1):
      tcp: advertise MSS requested by user

Yinghai Lu (2):
      firmware_map: fix hang with x86/32bit
      x86: handle initrd that extends into unusable memory

