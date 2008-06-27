Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbYF0Pyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbYF0Pyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 11:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYF0PyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 11:54:23 -0400
Received: from vena.lwn.net ([206.168.112.25]:54817 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbYF0PyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 11:54:20 -0400
Date: Fri, 27 Jun 2008 09:54:18 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>
Subject: The state of the BKL-removal tree
Message-ID: <20080627095418.2353267d@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bkl-removal tree lives at:

  git://git.lwn.net/linux-2.6.git bkl-removal

It has accumulated a fair amount of stuff at this point.  Lots of
pushdown work and a significant API change: the open() and fasync()
file_operations are now called without the big kernel lock.

This tree has been in linux-next since mid-May.  In the absence of
reasons to the contrary, my intent is to ask for this to be merged for
2.6.27.  Objections, anybody?

Andi Kleen (1):
      Remove BKL from remote_llseek v2

Arnd Bergmann (68):
      agp-frontend: BKL pushdown
      ans-lcd: BKL pushdown
      apm-emulation: BKL pushdown
      apm_32: BKL pushdown
      basler-excite: BKL pushdown
      bf561-coreb: BKL pushdown
      block-dasd_eer: BKL pushdown
      bluetooth-vhci: BKL pushdown
      briq_panel: BKL pushdown
      bvme6000-rtc: BKL pushdown
      cpwatchdog: BKL pushdown
      crypto-prng: BKL pushdown
      crypto-zcrypt_api: BKL pushdown
      display7seg: BKL pushdown
      dlm-user: BKL pushdown
      ds1286: BKL pushdown
      ds1620: BKL pushdown
      efirtc: BKL pushdown
      envctrl: BKL pushdown
      flash: BKL pushdown
      genrtc: BKL pushdown
      hdpu_cpustate: BKL pushdown
      hp_sdc_rtc: BKL pushdown
      hpet: BKL pushdown
      hw-random: BKL pushdown
      infiniband-ucma: BKL pushdown
      ip27-rtc: BKL pushdown
      ipmi-watchdog: BKL pushdown
      irnet_ppp: BKL pushdown
      jsflash: BKL pushdown
      lcd: BKL pushdown
      macintosh-smu: BKL pushdown
      media-radio-miropcm20-rds: BKL pushdown
      megaraid: BKL pushdown
      message-i2o-i2o_config: BKL pushdown
      microcode: BKL pushdown
      monreader: BKL pushdown
      monwriter: BKL pushdown
      mousedev: BKL pushdown
      mvme16x-rtc: BKL pushdown
      mwave-mwavedd: BKL pushdown
      net-tun: BKL pushdown
      nvram: BKL pushdown
      ocfs2-stack_user: BKL pushdown
      openprom: BKL pushdown
      parisc-eisa_eeprom: BKL pushdown
      parisc-kernel-perf: BKL pushdown
      pm_qos_params: BKL pushdown
      riowatchdog: BKL pushdown
      rtc: BKL pushdown
      rtc-rtc-m41t80: BKL pushdown
      sbus-rtc: BKL pushdown
      scsi-tgt: BKL pushdown
      serio: BKL pushdown
      sony-laptop: BKL pushdown
      sonypi: BKL pushdown
      sparc-apc: BKL pushdown
      sparc64-rtc: BKL pushdown
      tpm-tpm: BKL pushdown
      uctrl: BKL pushdown
      uinput: BKL pushdown
      uml-harddog: BKL pushdown
      uml-mmapper: BKL pushdown
      uml-random: BKL pushdown
      via-pmu: BKL pushdown
      vmcp: BKL pushdown
      vmwatchdog: BKL pushdown
      x86-mce: BKL pushdown

Jonathan Corbet (73):
      bsg: cdev lock_kernel() pushdown
      cris: cdev lock_kernel() pushdown
      mips: cdev lock_kernel() pushdown
      sh: cdev lock_kernel() pushdown
      x86: cdev lock_kernel() pushdown
      i2c: cdev lock_kernel() pushdown
      cosa: cdev lock_kernel() pushdown
      pcmcia: cdev lock_kernel() pushdown
      rtc: cdev lock_kernel() pushdown
      drivers/s390: cdev lock_kernel() pushdown
      AoE: cdev lock_kernel() pushdown
      paride: cdev lock_kernel() pushdown
      mtdchar: cdev lock_kernel() pushdown
      UBI: cdev lock_kernel() pushdown
      HID: cdev lock_kernel() pushdown
      Input: cdev lock_kernel() pushdown
      UIO: cdev lock_kernel() pushdown
      ipmi: cdev lock_kernel() pushdown
      mem: cdev lock_kernel() pushdown
      misc: cdev lock_kernel() pushdown
      viotape: cdev lock_kernel pushdown ()
      mbcs: cdev lock_kernel() pushdown
      lp: cdev lock_kernel() pushdown
      drm: cdev lock_kernel() pushdown
      phonedev: cdev lock_kernel() pushdown
      ide-tape: cdev lock_kernel() pushdown
      sg: cdev lock_kernel() pushdown
      osst: cdev lock_kernel() pushdown.
      aacraid: cdev lock_kernel() pushdown
      st: cdev lock_kernel() pushdown
      gdth: cdev lock_kernel() pushdown
      isdn: cdev lock_kernel() pushdown
      usbcore: cdev lock_kernel() pushdown
      dvb: cdev lock_kernel() pushdown
      fbmem: cdev lock_kernel() pushdown
      sound: cdev lock_kernel() pushdown
      snsc: cdev lock_kernel() pushdown
      tty: cdev lock_kernel() pushdown
      Add "no BKL needed" comments to several drivers
      spidev: BKL pushdown
      vcs: BKL pushdown
      xilinx icap: BKL pushdown
      tlckl: BKL pushdown
      raw: BKL pushdown
      dsp56k: BKL pushdown
      infiniband: more BKL pushdown
      phantom: BKL pushdown
      bpp: bkl pushdown
      videopix: BKL pushdown
      dpt_i20: BKL pushdown
      changer: BKL pushdown
      CAPI: BKL pushdown
      divamnt: BKL pushdown
      adb: BKL pushdown
      printer gadget: BKL pushdown
      USB Monitor: BKL pushdown
      usbdev: BKL pushdown
      videodev: BKL pushdown
      Add cycle_kernel_lock()
      Add a bunch of cycle_kernel_lock() calls
      Add a comment in chrdev_open()
      Remove the lock_kernel() call from chrdev_open()
      Make FAT users happier by not deadlocking
      Merge commit 'v2.6.26-rc6' into bkl-removal
      mpt: fasync BKL pushdown
      i2o: fasync BKL pushdown
      tun: fasync BKL pushdown
      tty_io: fasync BKL pushdown
      Bluetooth VHCI: fasync BKL pushdown
      ecryptfs: fasync BKL pushdown
      ipmi: fasync BKL pushdown
      snd/PCM: fasync BKL pushdown
      Call fasync() functions without the BKL

Linus Torvalds (1):
      Replace BKL with superblock lock in fat/msdos/vfat

Stephen Rothwell (1):
      bkl-removal viotape fixup

 arch/blackfin/mach-bf561/coreb.c             |    4 ++
 arch/cris/arch-v10/drivers/eeprom.c          |    4 +-
 arch/cris/arch-v10/drivers/gpio.c            |    3 ++
 arch/cris/arch-v10/drivers/i2c.c             |    2 +
 arch/cris/arch-v10/drivers/sync_serial.c     |   34 +++++++++++++--------
 arch/cris/arch-v32/drivers/cryptocop.c       |    3 +-
 arch/cris/arch-v32/drivers/i2c.c             |    2 +
 arch/cris/arch-v32/drivers/mach-a3/gpio.c    |    4 ++
 arch/cris/arch-v32/drivers/mach-fs/gpio.c    |    5 ++-
 arch/cris/arch-v32/drivers/sync_serial.c     |   33 ++++++++++++--------
 arch/m68k/bvme6000/rtc.c                     |    7 ++++-
 arch/m68k/mvme16x/rtc.c                      |    4 ++
 arch/mips/basler/excite/excite_iodev.c       |    9 +++++-
 arch/mips/kernel/rtlx.c                      |    7 ++++-
 arch/mips/kernel/vpe.c                       |   12 ++++++--
 arch/mips/sibyte/common/sb_tbprof.c          |   25 +++++++++++----
 arch/parisc/kernel/perf.c                    |    4 ++
 arch/s390/crypto/prng.c                      |    2 +
 arch/sh/boards/landisk/gio.c                 |   10 ++++--
 arch/sparc/kernel/apc.c                      |    2 +
 arch/sparc64/kernel/time.c                   |    7 ++++-
 arch/um/drivers/harddog_kern.c               |    3 ++
 arch/um/drivers/mmapper_kern.c               |    2 +
 arch/um/drivers/random.c                     |    3 ++
 arch/x86/kernel/apm_32.c                     |    4 ++
 arch/x86/kernel/cpu/mcheck/mce_64.c          |    4 ++
 arch/x86/kernel/cpuid.c                      |   25 +++++++++++-----
 arch/x86/kernel/microcode.c                  |    2 +
 arch/x86/kernel/msr.c                        |   16 +++++++--
 block/bsg.c                                  |    7 ++++-
 drivers/block/aoe/aoechr.c                   |    7 ++++-
 drivers/block/paride/pg.c                    |   22 ++++++++++----
 drivers/block/paride/pt.c                    |    8 ++++-
 drivers/bluetooth/hci_vhci.c                 |   14 +++++++--
 drivers/char/agp/frontend.c                  |    4 ++
 drivers/char/apm-emulation.c                 |    3 ++
 drivers/char/briq_panel.c                    |    9 ++++-
 drivers/char/cs5535_gpio.c                   |    2 +
 drivers/char/drm/drm_fops.c                  |    9 ++++-
 drivers/char/ds1286.c                        |    4 ++
 drivers/char/ds1620.c                        |    9 +++++-
 drivers/char/dsp56k.c                        |   16 +++++++---
 drivers/char/dtlk.c                          |    3 ++
 drivers/char/efirtc.c                        |    2 +
 drivers/char/genrtc.c                        |    7 ++++-
 drivers/char/hpet.c                          |    4 ++
 drivers/char/hw_random/core.c                |    2 +
 drivers/char/ip2/ip2main.c                   |   34 +--------------------
 drivers/char/ip27-rtc.c                      |    4 ++
 drivers/char/ipmi/ipmi_devintf.c             |   10 +++++-
 drivers/char/ipmi/ipmi_watchdog.c            |    3 ++
 drivers/char/lcd.c                           |    3 ++
 drivers/char/lp.c                            |   38 ++++++++++++++++-------
 drivers/char/mbcs.c                          |    5 +++
 drivers/char/mem.c                           |   10 +++++-
 drivers/char/misc.c                          |    3 ++
 drivers/char/mwave/mwavedd.c                 |    2 +
 drivers/char/nvram.c                         |    4 ++
 drivers/char/pc8736x_gpio.c                  |    2 +
 drivers/char/ppdev.c                         |    2 +
 drivers/char/raw.c                           |    3 ++
 drivers/char/rtc.c                           |    4 ++
 drivers/char/scx200_gpio.c                   |    2 +
 drivers/char/snsc.c                          |    5 ++-
 drivers/char/sonypi.c                        |    3 ++
 drivers/char/tb0219.c                        |    2 +
 drivers/char/tlclk.c                         |   19 +++++++----
 drivers/char/tpm/tpm.c                       |    5 +++
 drivers/char/tty_io.c                        |   41 +++++++++++++++++++++----
 drivers/char/vc_screen.c                     |    9 ++++-
 drivers/char/viotape.c                       |    3 ++
 drivers/char/vr41xx_giu.c                    |    2 +
 drivers/char/xilinx_hwicap/xilinx_hwicap.c   |    6 +++-
 drivers/hid/hidraw.c                         |    3 ++
 drivers/i2c/i2c-dev.c                        |   22 ++++++++++----
 drivers/ide/ide-tape.c                       |    7 ++++-
 drivers/infiniband/core/ucm.c                |    2 +
 drivers/infiniband/core/ucma.c               |    3 ++
 drivers/infiniband/core/user_mad.c           |    7 ++++-
 drivers/infiniband/core/uverbs_main.c        |    9 ++++-
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    2 +
 drivers/input/input.c                        |   16 +++++++--
 drivers/input/misc/hp_sdc_rtc.c              |    2 +
 drivers/input/misc/uinput.c                  |    3 ++
 drivers/input/mousedev.c                     |   12 ++++++-
 drivers/input/serio/serio_raw.c              |    6 +++-
 drivers/isdn/capi/capi.c                     |   17 +++++++----
 drivers/isdn/hardware/eicon/divamnt.c        |   16 +++++++---
 drivers/isdn/hardware/eicon/divasi.c         |    2 +
 drivers/isdn/hardware/eicon/divasmain.c      |    2 +
 drivers/isdn/i4l/isdn_common.c               |    3 +-
 drivers/macintosh/adb.c                      |   18 ++++++++---
 drivers/macintosh/ans-lcd.c                  |    2 +
 drivers/macintosh/smu.c                      |    3 ++
 drivers/macintosh/via-pmu.c                  |    3 ++
 drivers/media/dvb/dvb-core/dvbdev.c          |    4 ++
 drivers/media/radio/miropcm20-rds.c          |    4 ++
 drivers/media/video/videodev.c               |    4 ++
 drivers/message/fusion/mptctl.c              |    6 +++-
 drivers/message/i2o/i2o_config.c             |   12 +++++--
 drivers/misc/hdpuftrs/hdpu_cpustate.c        |    9 +++++-
 drivers/misc/phantom.c                       |    9 ++++-
 drivers/misc/sony-laptop.c                   |    3 ++
 drivers/mtd/mtdchar.c                        |   22 ++++++++++----
 drivers/mtd/ubi/cdev.c                       |    7 ++++-
 drivers/net/ppp_generic.c                    |    2 +
 drivers/net/tun.c                            |   13 ++++++--
 drivers/net/wan/cosa.c                       |   22 ++++++++++----
 drivers/parisc/eisa_eeprom.c                 |    3 ++
 drivers/pcmcia/pcmcia_ioctl.c                |   25 +++++++++++----
 drivers/rtc/rtc-dev.c                        |   12 ++++++--
 drivers/rtc/rtc-m41t80.c                     |    7 ++++-
 drivers/s390/block/dasd_eer.c                |    6 ++++
 drivers/s390/char/fs3270.c                   |   23 ++++++++++----
 drivers/s390/char/monreader.c                |    4 ++
 drivers/s390/char/monwriter.c                |    3 ++
 drivers/s390/char/tape_char.c                |   12 ++++++--
 drivers/s390/char/vmcp.c                     |    4 ++
 drivers/s390/char/vmlogrdr.c                 |    8 ++++-
 drivers/s390/char/vmur.c                     |   12 ++++++--
 drivers/s390/char/vmwatchdog.c               |    7 ++++-
 drivers/s390/crypto/zcrypt_api.c             |    3 ++
 drivers/sbus/char/bpp.c                      |    3 ++
 drivers/sbus/char/cpwatchdog.c               |    4 ++
 drivers/sbus/char/display7seg.c              |    1 +
 drivers/sbus/char/envctrl.c                  |    2 +
 drivers/sbus/char/flash.c                    |    6 +++-
 drivers/sbus/char/jsflash.c                  |   13 ++++++--
 drivers/sbus/char/openprom.c                 |    3 ++
 drivers/sbus/char/riowatchdog.c              |    2 +
 drivers/sbus/char/rtc.c                      |    3 ++
 drivers/sbus/char/uctrl.c                    |    3 ++
 drivers/sbus/char/vfc_dev.c                  |    5 +++
 drivers/scsi/3w-9xxx.c                       |    3 ++
 drivers/scsi/3w-xxxx.c                       |    3 ++
 drivers/scsi/aacraid/linit.c                 |    3 ++
 drivers/scsi/ch.c                            |    4 ++
 drivers/scsi/dpt_i2o.c                       |    5 +++
 drivers/scsi/gdth.c                          |    3 ++
 drivers/scsi/megaraid.c                      |    5 ++-
 drivers/scsi/megaraid/megaraid_mm.c          |    2 +
 drivers/scsi/megaraid/megaraid_sas.c         |    2 +
 drivers/scsi/osst.c                          |   15 +++++++++-
 drivers/scsi/scsi_tgt_if.c                   |    2 +
 drivers/scsi/sg.c                            |   16 ++++++++--
 drivers/scsi/st.c                            |   11 ++++++-
 drivers/spi/spidev.c                         |    3 ++
 drivers/telephony/phonedev.c                 |    3 ++
 drivers/uio/uio.c                            |   17 +++++++---
 drivers/usb/core/devio.c                     |    2 +
 drivers/usb/core/file.c                      |    3 ++
 drivers/usb/gadget/printer.c                 |    3 +-
 drivers/usb/mon/mon_bin.c                    |    6 ++++
 drivers/video/fbmem.c                        |   15 +++++++--
 fs/char_dev.c                                |    7 ++--
 fs/cifs/cifsfs.c                             |    2 +-
 fs/dlm/user.c                                |    9 +++++-
 fs/ecryptfs/file.c                           |    3 ++
 fs/fat/cache.c                               |    2 +-
 fs/fat/dir.c                                 |    4 +-
 fs/fat/file.c                                |    6 ----
 fs/fat/inode.c                               |   26 ++++++++++------
 fs/fcntl.c                                   |    3 --
 fs/gfs2/ops_file.c                           |    4 +-
 fs/msdos/namei.c                             |   35 ++++++++++++----------
 fs/ncpfs/file.c                              |   12 +++++++-
 fs/nfs/file.c                                |    6 +++-
 fs/ocfs2/stack_user.c                        |    3 ++
 fs/read_write.c                              |   38 +++++++-----------------
 fs/smbfs/file.c                              |   11 ++++++-
 fs/vfat/namei.c                              |   35 ++++++++++++----------
 include/linux/fs.h                           |    3 +-
 include/linux/smp_lock.h                     |   13 ++++++++
 kernel/pm_qos_params.c                       |    7 ++++-
 net/irda/irnet/irnet.h                       |    1 +
 net/irda/irnet/irnet_ppp.c                   |    3 ++
 sound/core/pcm_native.c                      |    8 ++++-
 sound/core/sound.c                           |   15 +++++++++-
 sound/sound_core.c                           |    5 +++
 179 files changed, 1084 insertions(+), 352 deletions(-)


jon
