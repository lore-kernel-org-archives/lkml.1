Return-Path: <linux-kernel-owner+w=401wt.eu-S1751730AbZJWA7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbZJWA7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 20:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbZJWA7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 20:59:45 -0400
Received: from kroah.org ([198.145.64.141]:39498 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbZJWA7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 20:59:40 -0400
Date: Thu, 22 Oct 2009 17:37:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.31.5
Message-ID: <20091023003723.GC23961@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.31.5 kernel.  All users of the
2.6.31 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.31.4 and 2.6.31.5

The updated 2.6.31.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.31.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.31.y.git;a=summary

thanks,

greg k-h

------------


 Documentation/connector/cn_test.c             |    4 
 Documentation/connector/connector.txt         |    8 
 MAINTAINERS                                   |    2 
 Makefile                                      |    7 
 arch/arm/Makefile                             |    2 
 arch/arm/kernel/Makefile                      |    3 
 arch/arm/mach-pxa/cpufreq-pxa2xx.c            |    2 
 arch/cris/Makefile                            |    2 
 arch/cris/kernel/Makefile                     |    1 
 arch/mips/Makefile                            |   27 -
 arch/mips/kernel/vmlinux.lds.S                |   13 
 arch/powerpc/Makefile                         |    2 
 arch/sparc/Makefile                           |    4 
 arch/sparc/kernel/Makefile                    |    6 
 arch/um/Makefile                              |    9 
 arch/um/kernel/Makefile                       |    3 
 arch/um/kernel/vmlinux.lds.S                  |    3 
 arch/x86/include/asm/paravirt.h               |   38 --
 arch/xtensa/kernel/Makefile                   |    3 
 drivers/char/tpm/tpm.c                        |    8 
 drivers/char/tty_buffer.c                     |   29 -
 drivers/connector/cn_proc.c                   |    3 
 drivers/connector/cn_queue.c                  |   15 
 drivers/connector/connector.c                 |   24 -
 drivers/i2c/busses/i2c-amd756.c               |    2 
 drivers/i2c/busses/i2c-amd8111.c              |    4 
 drivers/i2c/busses/i2c-i801.c                 |    4 
 drivers/i2c/busses/i2c-isch.c                 |    2 
 drivers/i2c/busses/i2c-piix4.c                |    4 
 drivers/i2c/busses/i2c-sis96x.c               |    2 
 drivers/i2c/busses/i2c-viapro.c               |    2 
 drivers/macintosh/therm_adt746x.c             |    4 
 drivers/macintosh/therm_pm72.c                |    4 
 drivers/macintosh/windfarm_lm75_sensor.c      |    4 
 drivers/macintosh/windfarm_max6690_sensor.c   |    4 
 drivers/macintosh/windfarm_smu_sat.c          |    4 
 drivers/md/dm-log-userspace-transfer.c        |    6 
 drivers/net/e1000e/82571.c                    |    4 
 drivers/net/wireless/iwlwifi/iwl-eeprom.c     |   23 -
 drivers/pci/dmar.c                            |   22 +
 drivers/scsi/scsi.c                           |   11 
 drivers/scsi/scsi_error.c                     |    3 
 drivers/scsi/sg.c                             |   10 
 drivers/staging/dst/dcore.c                   |    8 
 drivers/staging/pohmelfs/config.c             |    6 
 drivers/staging/rt2860/common/cmm_data_2860.c |    2 
 drivers/usb/serial/cp210x.c                   |    1 
 drivers/usb/serial/digi_acceleport.c          |    8 
 drivers/usb/serial/ftdi_sio.c                 |  422 +++++++-------------------
 drivers/usb/serial/generic.c                  |    2 
 drivers/usb/serial/ipaq.c                     |    9 
 drivers/usb/serial/option.c                   |    2 
 drivers/usb/serial/pl2303.c                   |    8 
 drivers/usb/serial/usb-serial.c               |    6 
 drivers/usb/storage/transport.c               |   46 ++
 drivers/video/uvesafb.c                       |    6 
 drivers/w1/w1_netlink.c                       |    3 
 fs/sysfs/file.c                               |   14 
 include/linux/connector.h                     |   11 
 include/linux/usb/serial.h                    |    1 
 include/net/bluetooth/hci_core.h              |    4 
 kernel/acct.c                                 |    8 
 kernel/futex.c                                |   39 +-
 kernel/trace/trace_events_filter.c            |    3 
 net/bluetooth/hci_conn.c                      |   17 -
 net/bluetooth/hci_event.c                     |    2 
 net/bluetooth/hidp/core.c                     |   65 ++--
 net/bluetooth/hidp/hidp.h                     |    2 
 net/mac80211/rx.c                             |   10 
 net/mac80211/sta_info.c                       |    2 
 net/mac80211/tx.c                             |    3 
 scripts/Makefile.build                        |    3 
 sound/aoa/codecs/tas.c                        |    9 
 sound/ppc/keywest.c                           |   12 
 74 files changed, 525 insertions(+), 546 deletions(-)

Alan Stern (3):
      USB: serial: don't call release without attach
      USB: ipaq: fix oops when device is plugged in
      USB: storage: When a device returns no sense data, call it a Hardware Error

Alexander Duyck (1):
      e1000e: swap max hw supported frame size between 82574 and 82583

Benjamin Herrenschmidt (1):
      usb-storage: Workaround devices with bogus sense size

Christof Schmitt (1):
      SCSI: sg: Free data buffers after calling blk_rq_unmap_user

Darren Hart (2):
      futex: Detect mismatched requeue targets
      futex: Fix wakeup race by setting TASK_INTERRUPTIBLE before queue_me()

Darren Salt (1):
      Staging: rt2860sta: prevent a panic when disabling when associated

David Woodhouse (1):
      intel-iommu: Cope with broken HP DC7900 BIOS

Dennis O'Brien (1):
      ARM: pxa: workaround errata #37 by not using half turbo switching

Greg Kroah-Hartman (1):
      Linux 2.6.31.5

Hannes Reinecke (1):
      SCSI: Retry ADD_TO_MLQUEUE return value for EH commands

Jason Gunthorpe (1):
      tpm-fixup-pcrs-sysfs-file-update

Jay Sternberg (1):
      iwlwifi: incorrect method used for finding valid OTP blocks

Jean Delvare (3):
      MAINTAINERS: Fix Riku Voipio's address
      macintosh: Don't assume i2c device probing always succeeds
      i2c: Hide probe errors caused by ACPI resource conflicts

Jeremy Fitzhardinge (1):
      x86/paravirt: Use normal calling sequences for irq enable/disable

Johan Hovold (6):
      USB: ftdi_sio: remove tty->low_latency
      USB: ftdi_sio: remove unused rx_byte counter
      USB: ftdi_sio: clean up read completion handler
      USB: ftdi_sio: re-implement read processing
      USB: pl2303: fix error characters not being reported to ldisc
      USB: digi_acceleport: Fix broken unthrottle.

Johannes Berg (1):
      mac80211: fix vlan and optimise RX

Joris van Rantwijk (1):
      USB: Fix throttling in generic usbserial driver

Li Zefan (1):
      tracing/filters: Fix memory leak when setting a filter

Linus Torvalds (1):
      tty: Make flush_to_ldisc() locking more robust

Marcel Holtmann (3):
      Bluetooth: Disconnect HIDRAW devices on disconnect
      Bluetooth: Add extra device reference counting for connections
      Bluetooth: Let HIDP grab the device reference for connections

Martin K. Petersen (1):
      SCSI: Fix protection scsi_data_buffer leak

Michal Schmidt (1):
      bsdacct: switch credentials for writing to the accounting file

Neil Brown (1):
      sysfs: Allow sysfs_notify_dirent to be called from interrupt context.

Peter Magdina (1):
      USB: option: Toshiba G450 device id

Philipp Reisner (7):
      connector: Keep the skb in cn_callback_data
      connector: Provide the sender's credentials to the callback
      connector: Removed the destruct_data callback since it is always kfree_skb()
      dm/connector: Only process connector packages from privileged processes
      dst/connector: Disallow unpliviged users to configure dst
      pohmelfs/connector: Disallow unpliviged users to configure pohmelfs
      uvesafb/connector: Disallow unpliviged users to send netlink packets

Rajiv Andrade (1):
      TPM: fix pcrread

Sam Ravnborg (1):
      arm, cris, mips, sparc, powerpc, um, xtensa: fix build with bash 4.0

Takashi Iwai (1):
      ALSA: Don't assume i2c device probing always succeeds

Éric Piel (1):
      USB: cp210x: Add support for the DW700 UART

