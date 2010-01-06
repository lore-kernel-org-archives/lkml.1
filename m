Return-Path: <linux-kernel-owner+w=401wt.eu-S933095Ab0AFXrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095Ab0AFXrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932979Ab0AFXri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:47:38 -0500
Received: from kroah.org ([198.145.64.141]:34538 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932967Ab0AFXrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:47:37 -0500
Date: Wed, 6 Jan 2010 15:45:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.31.10
Message-ID: <20100106234533.GC1960@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.31.10 kernel.  All users of the
2.6.31 kernel series are very strongly encouraged to upgrade.

NOTE:
  This is probably the next-to-last release of the 2.6.31 kernel series,
  barring anything unexpected.  All users relying on this kernel version
  should now move to the 2.6.32 series as the .31 series will be ending
  its lifecycle with the next release.

The updated 2.6.31.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.31.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.31.y.git;a=summary

thanks,

greg k-h

------------


 Makefile                                       |    2 
 arch/x86/include/asm/processor.h               |    2 
 arch/x86/kernel/ptrace.c                       |   16 -
 drivers/ata/pata_cmd64x.c                      |    2 
 drivers/ata/pata_hpt3x2n.c                     |   64 ++++---
 drivers/dma/at_hdmac.c                         |    4 
 drivers/hwmon/fschmd.c                         |    2 
 drivers/hwmon/sht15.c                          |    6 
 drivers/i2c/chips/tsl2550.c                    |    3 
 drivers/input/keyboard/atkbd.c                 |    9 +
 drivers/md/md.c                                |    8 
 drivers/media/video/ov511.c                    |    2 
 drivers/net/e100.c                             |   19 +-
 drivers/net/usb/rtl8150.c                      |    2 
 drivers/net/wireless/hostap/hostap_main.c      |    3 
 drivers/net/wireless/libertas/wext.c           |    2 
 drivers/net/wireless/rt2x00/rt61pci.c          |    5 
 drivers/platform/x86/acerhdf.c                 |    7 
 drivers/s390/block/dasd_diag.c                 |   19 +-
 drivers/scsi/scsi_transport_fc.c               |   17 +
 drivers/usb/misc/appledisplay.c                |    4 
 drivers/usb/misc/emi62.c                       |    2 
 drivers/usb/musb/musb_gadget_ep0.c             |   14 +
 drivers/usb/serial/option.c                    |    5 
 fs/cifs/connect.c                              |   13 +
 fs/ext4/ext4.h                                 |    6 
 fs/ext4/inode.c                                |   27 +--
 fs/ext4/super.c                                |    5 
 fs/namei.c                                     |    1 
 fs/quota/dquot.c                               |  213 +++++++++++++------------
 fs/stat.c                                      |   10 -
 fs/udf/super.c                                 |   32 ++-
 fs/xfs/xfs_log_recover.c                       |    4 
 include/linux/fs.h                             |    1 
 include/linux/quota.h                          |    5 
 include/net/ipv6.h                             |    7 
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |    2 
 kernel/time/clockevents.c                      |   18 +-
 mm/memcontrol.c                                |    8 
 mm/oom_kill.c                                  |    2 
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   13 +
 net/ipv6/netfilter/nf_conntrack_reasm.c        |    7 
 net/ipv6/reassembly.c                          |    5 
 sound/mips/sgio2audio.c                        |    2 
 sound/pcmcia/pdaudiocf/pdaudiocf_pcm.c         |    2 
 sound/soc/codecs/wm9712.c                      |    3 
 sound/usb/usbaudio.c                           |    2 
 47 files changed, 388 insertions(+), 219 deletions(-)

Bartlomiej Zolnierkiewicz (1):
      pata_cmd64x: fix overclocking of UDMA0-2 modes

Clemens Ladisch (2):
      sound: sgio2audio/pdaudiocf/usb-audio: initialize PCM buffer
      USB: emi62: fix crash when trying to load EMI 6|2 firmware

Daisuke Nishimura (1):
      memcg: avoid oom-killing innocent task in case of use_hierarchy

Dan Carpenter (1):
      V4L/DVB (13596): ov511.c typo: lock => unlock

Daniel Mack (1):
      Libertas: fix buffer overflow in lbs_get_essid()

Dmitry Monakhov (4):
      Add unlocked version of inode_add_bytes() function
      quota: decouple fs reserved space from quota reservation
      ext4: Convert to generic reserved quota's space management.
      ext4: fix sleep inside spinlock issue with quota and dealloc (#14739)

Donny Kurnia (1):
      USB: option: support hi speed for modem Haier CE100

Eric Millbrandt (1):
      ASoC: Do not write to invalid registers on the wm9712.

Gertjan van Wingerde (1):
      rt2x00: Disable powersaving for rt61pci and rt2800pci.

Greg Kroah-Hartman (1):
      Linux 2.6.31.10

Jan Kara (1):
      udf: Try harder when looking for VAT inode

Jan Rekorajski (1):
      XFS bug in log recover with quota (bugzilla id 855)

Jeff Layton (1):
      cifs: NULL out tcon, pSesInfo, and srvTcp pointers when chasing DFS referrals

Jonathan Cameron (1):
      hwmon: (sht15) Off-by-one error in array index + incorrect constants

Julia Lawall (1):
      drivers/net/usb: Correct code taking the size of a pointer

Linus Torvalds (1):
      x86/ptrace: make genregs[32]_get/set more robust

Martin Decky (1):
      hostap: Revert a toxic part of the conversion to net_device_ops

Michele Jr De Candia (1):
      i2c/tsl2550: Fix lux value in extended mode

Mike Christie (1):
      SCSI: fc class: fix fc_transport_init error handling

Moiseev Vladimir (1):
      Input: atkbd - add force relese key quirk for Samsung R59P/R60P/R61P

NeilBrown (1):
      md: Fix unfortunate interaction with evms

Nicolas Ferre (1):
      dma: at_hdmac: correct incompatible type for argument 1 of 'spin_lock_bh'

Patrick McHardy (1):
      ipv6: reassembly: use seperate reassembly queues for conntrack and local delivery

Roel Kluin (1):
      hwmon: (fschmd) Fix check on unsigned in watchdog_write()

Roger Oksanen (2):
      e100: Use pci pool to work around GFP_ATOMIC order 5 memory allocation failure
      e100: Fix broken cbs accounting due to missing memset.

Serge E. Hallyn (1):
      generic_permission: MAY_OPEN is not write access

Sergei Shtylyov (2):
      pata_hpt3x2n: fix clock turnaround
      USB: musb: gadget_ep0: avoid SetupEnd interrupt

Stefan Bader (1):
      acerhdf: limit modalias matching to supported

Stefan Weinhuber (1):
      S390: dasd: support DIAG access for read-only devices

Suresh Siddha (1):
      x86, cpuid: Add "volatile" to asm in native_cpuid()

Thomas Gleixner (1):
      clockevents: Prevent clockevent_devices list corruption on cpu hotplug

pancho horrillo (1):
      USB: Fix a bug on appledisplay.c regarding signedness

