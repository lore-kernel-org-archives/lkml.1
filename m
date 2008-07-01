Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbYGAXGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbYGAXGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 19:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbYGAXGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 19:06:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:40933 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYGAXGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 19:06:31 -0400
Date: Tue, 1 Jul 2008 16:01:57 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: linux-staging for 2.6.26-rc8
Message-ID: <20080701230156.GA9335@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the announcement for the linux-staging tree for 2.6.26-rc8.

It currently contains 20+ drivers and one filesystem.

It can be downloaded from:
	http://www.kernel.org/pub/linux/kernel/people/gregkh/linux-staging/linux-staging-2.6.26-rc8.bz2

Differences from the 2.6.26-rc7 release:
 - added mimio-xi input driver
 - added wireless USB and UWB stacks as they were not playing well in
   the USB tree
 - added the vmware drivers vmmon, vmnet and vmblock as they are now
   released under the GPLv2.

Diffstat of the whole tree can be found below along with the shortlog
entry.  I'll respond to this message with the current status of the
individual patches for people who are interested in it.

For details about what the linux-staging tree is, how to use it, and the
rules for it, please see the README file in the git tree at:
	http://git.kernel.org/?p=linux/kernel/git/gregkh/staging.git;a=blob;f=README

The linux-staging tree can be found in git as a series of quilt patches
at:
	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git


thanks,

greg k-h

-----------------------

 Documentation/fb/viafb.modes                |  870 +++
 Documentation/fb/viafb.txt                  |  232 +
 Documentation/usb/WUSB-Design-overview.txt  |  448 ++
 Documentation/usb/wusb-cbaf                 |  133 +
 arch/arm/Kconfig                            |    2 +
 arch/cris/Kconfig                           |    2 +
 arch/h8300/Kconfig                          |    2 +
 arch/v850/Kconfig                           |    2 +
 drivers/Kconfig                             |    4 +
 drivers/Makefile                            |    2 +
 drivers/char/drm/Kconfig                    |    7 +
 drivers/char/drm/Makefile                   |    2 +
 drivers/char/drm/drm_pciids.h               |    9 +-
 drivers/char/drm/via_3d_reg.h               |   12 +-
 drivers/char/drm/via_chrome9_3d_reg.h       |  395 ++
 drivers/char/drm/via_chrome9_dma.c          | 1147 +++
 drivers/char/drm/via_chrome9_dma.h          |   68 +
 drivers/char/drm/via_chrome9_drm.c          |  993 +++
 drivers/char/drm/via_chrome9_drm.h          |  423 ++
 drivers/char/drm/via_chrome9_drv.c          |  153 +
 drivers/char/drm/via_chrome9_drv.h          |  145 +
 drivers/char/drm/via_chrome9_mm.c           |  388 ++
 drivers/char/drm/via_chrome9_mm.h           |   67 +
 drivers/char/drm/via_dma.c                  |  353 +-
 drivers/char/drm/via_dmablit.c              |  326 +-
 drivers/char/drm/via_dmablit.h              |   22 +-
 drivers/char/drm/via_drm.h                  |  144 +-
 drivers/char/drm/via_drv.c                  |   13 +-
 drivers/char/drm/via_drv.h                  |   93 +-
 drivers/char/drm/via_irq.c                  |   66 +-
 drivers/char/drm/via_map.c                  |   75 +-
 drivers/char/drm/via_mm.c                   |  249 +-
 drivers/char/drm/via_verifier.c             |  269 +-
 drivers/char/drm/via_verifier.h             |   64 +-
 drivers/char/drm/via_video.c                |   70 +-
 drivers/hid/usbhid/hid-quirks.c             |    2 +
 drivers/input/misc/Kconfig                  |   23 +
 drivers/input/misc/Makefile                 |    2 +
 drivers/input/misc/appleir.c                |  361 +
 drivers/input/misc/mimio.c                  |  913 +++
 drivers/media/dvb/Kconfig                   |    2 +
 drivers/media/dvb/Makefile                  |    2 +-
 drivers/media/dvb/firesat/Kconfig           |   11 +
 drivers/media/dvb/firesat/Makefile          |   12 +
 drivers/media/dvb/firesat/avc_api.c         |  848 +++
 drivers/media/dvb/firesat/avc_api.h         |  381 +
 drivers/media/dvb/firesat/cmp.c             |  230 +
 drivers/media/dvb/firesat/cmp.h             |    9 +
 drivers/media/dvb/firesat/firesat-ci.c      |   95 +
 drivers/media/dvb/firesat/firesat-ci.h      |    9 +
 drivers/media/dvb/firesat/firesat-rc.c      |   84 +
 drivers/media/dvb/firesat/firesat-rc.h      |    9 +
 drivers/media/dvb/firesat/firesat.h         |   85 +
 drivers/media/dvb/firesat/firesat_1394.c    |  468 ++
 drivers/media/dvb/firesat/firesat_dvb.c     |  350 +
 drivers/media/dvb/firesat/firesat_fe.c      |  263 +
 drivers/media/video/Kconfig                 |   10 +
 drivers/media/video/Makefile                |    3 +
 drivers/media/video/go7007/Kconfig          |   23 +
 drivers/media/video/go7007/Makefile         |   18 +
 drivers/media/video/go7007/go7007-driver.c  |  693 ++
 drivers/media/video/go7007/go7007-fw.c      | 1643 +++++
 drivers/media/video/go7007/go7007-i2c.c     |  309 +
 drivers/media/video/go7007/go7007-priv.h    |  279 +
 drivers/media/video/go7007/go7007-usb.c     | 1228 ++++
 drivers/media/video/go7007/go7007-v4l2.c    | 1509 ++++
 drivers/media/video/go7007/go7007.h         |  120 +
 drivers/media/video/go7007/saa7134-go7007.c |  484 ++
 drivers/media/video/go7007/snd-go7007.c     |  315 +
 drivers/media/video/go7007/wis-i2c.h        |   55 +
 drivers/media/video/go7007/wis-ov7640.c     |  146 +
 drivers/media/video/go7007/wis-saa7113.c    |  378 +
 drivers/media/video/go7007/wis-saa7115.c    |  507 ++
 drivers/media/video/go7007/wis-sony-tuner.c |  757 ++
 drivers/media/video/go7007/wis-tw2804.c     |  383 +
 drivers/media/video/go7007/wis-tw9903.c     |  378 +
 drivers/media/video/go7007/wis-uda1342.c    |  136 +
 drivers/media/video/s2255drv.c              | 2486 +++++++
 drivers/misc/Kconfig                        |   32 +
 drivers/misc/Makefile                       |    4 +
 drivers/misc/aectc/Makefile                 |    1 +
 drivers/misc/aectc/aec_tc.c                 |  349 +
 drivers/misc/aectc/aectc.h                  |   18 +
 drivers/misc/aectc/read.c                   |   63 +
 drivers/misc/aectc/write.c                  |   64 +
 drivers/misc/kolter_1616.c                  |  199 +
 drivers/misc/me4000.c                       | 6133 ++++++++++++++++
 drivers/misc/me4000.h                       |  954 +++
 drivers/misc/me4000_firmware.h              |10033 +++++++++++++++++++++++++++
 drivers/misc/me4610_firmware.h              | 5409 +++++++++++++++
 drivers/misc/oms/Makefile                   |    2 +
 drivers/misc/oms/oms-core.c                 | 1295 ++++
 drivers/misc/oms/oms-core.h                 |  143 +
 drivers/misc/oms/oms-maxp.h                 |   85 +
 drivers/misc/oms/oms-maxpdrv.c              | 1292 ++++
 drivers/misc/oms/oms-maxpdrv.h              |  142 +
 drivers/misc/oms/oms-pcix.h                 |   67 +
 drivers/misc/oms/oms-pcixdrv.c              | 1119 +++
 drivers/misc/oms/oms-pcixdrv.h              |   61 +
 drivers/misc/oms/oms.h                      |   78 +
 drivers/net/Kconfig                         |   32 +
 drivers/net/Makefile                        |    3 +
 drivers/net/et131x/Makefile                 |   18 +
 drivers/net/et131x/et1310_address_map.h     | 2399 +++++++
 drivers/net/et131x/et1310_eeprom.c          |  480 ++
 drivers/net/et131x/et1310_eeprom.h          |   89 +
 drivers/net/et131x/et1310_jagcore.c         |  220 +
 drivers/net/et131x/et1310_jagcore.h         |  112 +
 drivers/net/et131x/et1310_mac.c             |  792 +++
 drivers/net/et131x/et1310_mac.h             |   93 +
 drivers/net/et131x/et1310_phy.c             | 1281 ++++
 drivers/net/et131x/et1310_phy.h             |  910 +++
 drivers/net/et131x/et1310_pm.c              |  207 +
 drivers/net/et131x/et1310_pm.h              |  125 +
 drivers/net/et131x/et1310_rx.c              | 1391 ++++
 drivers/net/et131x/et1310_rx.h              |  373 +
 drivers/net/et131x/et1310_tx.c              | 1525 ++++
 drivers/net/et131x/et1310_tx.h              |  242 +
 drivers/net/et131x/et131x_adapter.h         |  347 +
 drivers/net/et131x/et131x_config.c          |  325 +
 drivers/net/et131x/et131x_config.h          |   67 +
 drivers/net/et131x/et131x_debug.c           |  218 +
 drivers/net/et131x/et131x_debug.h           |  201 +
 drivers/net/et131x/et131x_defs.h            |  128 +
 drivers/net/et131x/et131x_initpci.c         | 1046 +++
 drivers/net/et131x/et131x_initpci.h         |   73 +
 drivers/net/et131x/et131x_isr.c             |  488 ++
 drivers/net/et131x/et131x_isr.h             |   65 +
 drivers/net/et131x/et131x_netdev.c          |  856 +++
 drivers/net/et131x/et131x_netdev.h          |   64 +
 drivers/net/et131x/et131x_version.h         |   81 +
 drivers/net/slicoss/Makefile                |    1 +
 drivers/net/slicoss/gbdownload.h            | 8215 ++++++++++++++++++++++
 drivers/net/slicoss/gbrcvucode.h            |  239 +
 drivers/net/slicoss/oasisdbgdownload.h      | 6850 ++++++++++++++++++
 drivers/net/slicoss/oasisdownload.h         | 6848 ++++++++++++++++++
 drivers/net/slicoss/oasisrcvucode.h         |  205 +
 drivers/net/slicoss/slic.h                  |  619 ++
 drivers/net/slicoss/slic_os.h               |  150 +
 drivers/net/slicoss/slicbuild.h             |   97 +
 drivers/net/slicoss/slicdbg.h               |  100 +
 drivers/net/slicoss/slicdump.h              |  282 +
 drivers/net/slicoss/slichw.h                |  855 +++
 drivers/net/slicoss/slicinc.h               |  215 +
 drivers/net/slicoss/slicoss.c               | 6156 ++++++++++++++++
 drivers/net/usb/Kconfig                     |   10 +
 drivers/net/usb/Makefile                    |    1 +
 drivers/net/usb/hso.c                       | 2836 ++++++++
 drivers/usb/Kconfig                         |    2 +
 drivers/usb/Makefile                        |    3 +
 drivers/usb/class/Kconfig                   |   10 +
 drivers/usb/class/Makefile                  |    1 +
 drivers/usb/class/usbtmc.c                  | 1576 +++++
 drivers/usb/class/usbtmc.h                  |  144 +
 drivers/usb/core/hub.c                      |   83 +
 drivers/usb/host/Kconfig                    |   26 +
 drivers/usb/host/Makefile                   |    3 +
 drivers/usb/host/hwa-hc.c                   |  935 +++
 drivers/usb/host/whci/Kbuild                |   11 +
 drivers/usb/host/whci/asl.c                 |  366 +
 drivers/usb/host/whci/hcd.c                 |  339 +
 drivers/usb/host/whci/hw.c                  |   80 +
 drivers/usb/host/whci/init.c                |  181 +
 drivers/usb/host/whci/int.c                 |   95 +
 drivers/usb/host/whci/pzl.c                 |  398 ++
 drivers/usb/host/whci/qset.c                |  563 ++
 drivers/usb/host/whci/whcd.h                |  195 +
 drivers/usb/host/whci/whci-hc.h             |  413 ++
 drivers/usb/host/whci/wusb.c                |  241 +
 drivers/usb/wusbcore/Kconfig                |   17 +
 drivers/usb/wusbcore/Makefile               |   20 +
 drivers/usb/wusbcore/cbaf.c                 |  620 ++
 drivers/usb/wusbcore/crypto.c               |  538 ++
 drivers/usb/wusbcore/dev-sysfs.c            |  199 +
 drivers/usb/wusbcore/devconnect.c           | 1319 ++++
 drivers/usb/wusbcore/mmc.c                  |  329 +
 drivers/usb/wusbcore/pal.c                  |   39 +
 drivers/usb/wusbcore/reservation.c          |  115 +
 drivers/usb/wusbcore/rh.c                   |  477 ++
 drivers/usb/wusbcore/security.c             |  644 ++
 drivers/usb/wusbcore/wa-hc.c                |   83 +
 drivers/usb/wusbcore/wa-hc.h                |  416 ++
 drivers/usb/wusbcore/wa-nep.c               |  313 +
 drivers/usb/wusbcore/wa-rpipe.c             |  562 ++
 drivers/usb/wusbcore/wa-xfer.c              | 1709 +++++
 drivers/usb/wusbcore/wusbhc.c               |  392 ++
 drivers/usb/wusbcore/wusbhc.h               |  525 ++
 drivers/uwb/Kconfig                         |   90 +
 drivers/uwb/Makefile                        |   29 +
 drivers/uwb/address.c                       |  374 +
 drivers/uwb/beacon.c                        |  707 ++
 drivers/uwb/driver.c                        |  142 +
 drivers/uwb/drp-avail.c                     |  288 +
 drivers/uwb/drp-ie.c                        |  233 +
 drivers/uwb/drp.c                           |  451 ++
 drivers/uwb/est.c                           |  414 ++
 drivers/uwb/hwa-rc.c                        |  915 +++
 drivers/uwb/i1480/Makefile                  |    2 +
 drivers/uwb/i1480/dfu/Makefile              |    9 +
 drivers/uwb/i1480/dfu/dfu.c                 |  281 +
 drivers/uwb/i1480/dfu/i1480-dfu.h           |  263 +
 drivers/uwb/i1480/dfu/mac.c                 |  529 ++
 drivers/uwb/i1480/dfu/phy.c                 |  203 +
 drivers/uwb/i1480/dfu/usb.c                 |  501 ++
 drivers/uwb/i1480/i1480-est.c               |   99 +
 drivers/uwb/i1480/i1480-wlp.h               |  155 +
 drivers/uwb/i1480/i1480u-wlp/Makefile       |    8 +
 drivers/uwb/i1480/i1480u-wlp/i1480u-wlp.h   |  269 +
 drivers/uwb/i1480/i1480u-wlp/lc.c           |  421 ++
 drivers/uwb/i1480/i1480u-wlp/netdev.c       |  367 +
 drivers/uwb/i1480/i1480u-wlp/rx.c           |  491 ++
 drivers/uwb/i1480/i1480u-wlp/sysfs.c        |  446 ++
 drivers/uwb/i1480/i1480u-wlp/tx.c           |  638 ++
 drivers/uwb/ie.c                            |  570 ++
 drivers/uwb/lc-dev.c                        |  512 ++
 drivers/uwb/lc-rc.c                         |  485 ++
 drivers/uwb/neh.c                           |  615 ++
 drivers/uwb/pal.c                           |   71 +
 drivers/uwb/reset.c                         |  319 +
 drivers/uwb/rsv.c                           |  677 ++
 drivers/uwb/scan.c                          |  159 +
 drivers/uwb/umc-bus.c                       |  185 +
 drivers/uwb/umc-dev.c                       |  103 +
 drivers/uwb/umc-drv.c                       |   31 +
 drivers/uwb/uwb-debug.c                     |  367 +
 drivers/uwb/uwb-internal.h                  |  283 +
 drivers/uwb/uwbd.c                          |  425 ++
 drivers/uwb/whc-rc.c                        |  511 ++
 drivers/uwb/whci.c                          |  274 +
 drivers/uwb/wlp/Makefile                    |   10 +
 drivers/uwb/wlp/driver.c                    |   43 +
 drivers/uwb/wlp/eda.c                       |  449 ++
 drivers/uwb/wlp/messages.c                  | 1946 ++++++
 drivers/uwb/wlp/sysfs.c                     |  715 ++
 drivers/uwb/wlp/txrx.c                      |  374 +
 drivers/uwb/wlp/wlp-internal.h              |  228 +
 drivers/uwb/wlp/wlp-lc.c                    |  572 ++
 drivers/uwb/wlp/wss-lc.c                    | 1056 +++
 drivers/video/Kconfig                       |    6 +
 drivers/video/Makefile                      |    1 +
 drivers/video/viafb/Makefile                |    9 +
 drivers/video/viafb/accel.c                 |  244 +
 drivers/video/viafb/accel.h                 |  179 +
 drivers/video/viafb/chip.h                  |  190 +
 drivers/video/viafb/debug.h                 |   41 +
 drivers/video/viafb/dvi.c                   |  720 ++
 drivers/video/viafb/dvi.h                   |   64 +
 drivers/video/viafb/global.c                |   60 +
 drivers/video/viafb/global.h                |   92 +
 drivers/video/viafb/hw.c                    | 2878 ++++++++
 drivers/video/viafb/hw.h                    |  942 +++
 drivers/video/viafb/iface.c                 |   78 +
 drivers/video/viafb/iface.h                 |   38 +
 drivers/video/viafb/ioctl.c                 |  112 +
 drivers/video/viafb/ioctl.h                 |  212 +
 drivers/video/viafb/lcd.c                   | 1831 +++++
 drivers/video/viafb/lcd.h                   |   94 +
 drivers/video/viafb/lcdtbl.h                |  591 ++
 drivers/video/viafb/share.h                 | 1113 +++
 drivers/video/viafb/tbl1636.c               |   71 +
 drivers/video/viafb/tbl1636.h               |   34 +
 drivers/video/viafb/tblDPASetting.c         |  109 +
 drivers/video/viafb/tblDPASetting.h         |   47 +
 drivers/video/viafb/via_i2c.c               |  379 +
 drivers/video/viafb/via_i2c.h               |   36 +
 drivers/video/viafb/via_utility.c           |  301 +
 drivers/video/viafb/via_utility.h           |   35 +
 drivers/video/viafb/viafb.modes             |  870 +++
 drivers/video/viafb/viafbdev.c              | 2638 +++++++
 drivers/video/viafb/viafbdev.h              |  107 +
 drivers/video/viafb/viamode.c               | 1086 +++
 drivers/video/viafb/viamode.h               |  177 +
 drivers/video/viafb/vt1636.c                |  325 +
 drivers/video/viafb/vt1636.h                |   44 +
 drivers/vmware/Kconfig                      |   30 +
 drivers/vmware/Makefile                     |    7 +
 drivers/vmware/vmblock/Makefile             |   13 +
 drivers/vmware/vmblock/block.c              |  611 ++
 drivers/vmware/vmblock/block.h              |   47 +
 drivers/vmware/vmblock/compat_completion.h  |  175 +
 drivers/vmware/vmblock/compat_file.h        |   56 +
 drivers/vmware/vmblock/compat_fs.h          |  247 +
 drivers/vmware/vmblock/compat_init.h        |   38 +
 drivers/vmware/vmblock/compat_kernel.h      |   83 +
 drivers/vmware/vmblock/compat_list.h        |   55 +
 drivers/vmware/vmblock/compat_mm.h          |  134 +
 drivers/vmware/vmblock/compat_module.h      |   72 +
 drivers/vmware/vmblock/compat_namei.h       |   57 +
 drivers/vmware/vmblock/compat_page.h        |   75 +
 drivers/vmware/vmblock/compat_sched.h       |  274 +
 drivers/vmware/vmblock/compat_semaphore.h   |   44 +
 drivers/vmware/vmblock/compat_slab.h        |   70 +
 drivers/vmware/vmblock/compat_spinlock.h    |   68 +
 drivers/vmware/vmblock/compat_statfs.h      |   32 +
 drivers/vmware/vmblock/compat_string.h      |   42 +
 drivers/vmware/vmblock/compat_uaccess.h     |   79 +
 drivers/vmware/vmblock/compat_version.h     |  121 +
 drivers/vmware/vmblock/compat_wait.h        |  225 +
 drivers/vmware/vmblock/control.c            |  332 +
 drivers/vmware/vmblock/dbllnklst.c          |  399 ++
 drivers/vmware/vmblock/dbllnklst.h          |   69 +
 drivers/vmware/vmblock/dentry.c             |  122 +
 drivers/vmware/vmblock/driver-config.h      |   78 +
 drivers/vmware/vmblock/file.c               |  274 +
 drivers/vmware/vmblock/filesystem.c         |  618 ++
 drivers/vmware/vmblock/filesystem.h         |  111 +
 drivers/vmware/vmblock/inode.c              |  244 +
 drivers/vmware/vmblock/module.c             |  175 +
 drivers/vmware/vmblock/os.h                 |  117 +
 drivers/vmware/vmblock/stubs.c              |   52 +
 drivers/vmware/vmblock/stubs.h              |   36 +
 drivers/vmware/vmblock/super.c              |  194 +
 drivers/vmware/vmblock/vm_assert.h          |  308 +
 drivers/vmware/vmblock/vm_basic_defs.h      |  553 ++
 drivers/vmware/vmblock/vm_basic_types.h     |  847 +++
 drivers/vmware/vmblock/vmblock.h            |  105 +
 drivers/vmware/vmblock/vmblockInt.h         |   94 +
 drivers/vmware/vmblock/vmblock_version.h    |   32 +
 drivers/vmware/vmblock/vmware.h             |   58 +
 drivers/vmware/vmmon/COPYING                |  339 +
 drivers/vmware/vmmon/Makefile               |   13 +
 drivers/vmware/vmmon/basic_initblock.h      |   64 +
 drivers/vmware/vmmon/busmem_def.h           |   71 +
 drivers/vmware/vmmon/circList.h             |  428 ++
 drivers/vmware/vmmon/compat_completion.h    |  175 +
 drivers/vmware/vmmon/compat_file.h          |   56 +
 drivers/vmware/vmmon/compat_fs.h            |  247 +
 drivers/vmware/vmmon/compat_highmem.h       |   40 +
 drivers/vmware/vmmon/compat_interrupt.h     |   50 +
 drivers/vmware/vmmon/compat_kernel.h        |   83 +
 drivers/vmware/vmmon/compat_list.h          |   55 +
 drivers/vmware/vmmon/compat_mm.h            |  134 +
 drivers/vmware/vmmon/compat_module.h        |   72 +
 drivers/vmware/vmmon/compat_page.h          |   75 +
 drivers/vmware/vmmon/compat_pgtable.h       |  139 +
 drivers/vmware/vmmon/compat_sched.h         |  274 +
 drivers/vmware/vmmon/compat_semaphore.h     |   44 +
 drivers/vmware/vmmon/compat_slab.h          |   70 +
 drivers/vmware/vmmon/compat_spinlock.h      |   68 +
 drivers/vmware/vmmon/compat_timer.h         |   95 +
 drivers/vmware/vmmon/compat_uaccess.h       |   79 +
 drivers/vmware/vmmon/compat_version.h       |  121 +
 drivers/vmware/vmmon/compat_wait.h          |  225 +
 drivers/vmware/vmmon/comport.c              |  203 +
 drivers/vmware/vmmon/comport.h              |   41 +
 drivers/vmware/vmmon/contextinfo.h          |   93 +
 drivers/vmware/vmmon/cpuid.c                |  159 +
 drivers/vmware/vmmon/cpuid.h                |   41 +
 drivers/vmware/vmmon/cpuid_info.h           |  105 +
 drivers/vmware/vmmon/crossgdt.h             |   78 +
 drivers/vmware/vmmon/driver-config.h        |   78 +
 drivers/vmware/vmmon/driver.c               | 2608 +++++++
 drivers/vmware/vmmon/driver.h               |  109 +
 drivers/vmware/vmmon/driverLog.c            |  207 +
 drivers/vmware/vmmon/driverLog.h            |   37 +
 drivers/vmware/vmmon/driver_vmcore.h        |   35 +
 drivers/vmware/vmmon/hashFunc.c             |   61 +
 drivers/vmware/vmmon/hashFunc.h             |  316 +
 drivers/vmware/vmmon/hostKernel.h           |   83 +
 drivers/vmware/vmmon/hostif.c               | 3653 ++++++++++
 drivers/vmware/vmmon/hostif.h               |  202 +
 drivers/vmware/vmmon/includeCheck.h         |   17 +
 drivers/vmware/vmmon/initblock.h            |   43 +
 drivers/vmware/vmmon/iocontrols.h           |  753 ++
 drivers/vmware/vmmon/memtrack.c             |  381 +
 drivers/vmware/vmmon/memtrack.h             |   62 +
 drivers/vmware/vmmon/modulecall.h           |  512 ++
 drivers/vmware/vmmon/modulecallstructs.h    |   83 +
 drivers/vmware/vmmon/moduleloop.c           |  302 +
 drivers/vmware/vmmon/mon_assert.h           |   87 +
 drivers/vmware/vmmon/numa_defs.h            |   68 +
 drivers/vmware/vmmon/pgtbl.h                |  381 +
 drivers/vmware/vmmon/phystrack.c            |  384 +
 drivers/vmware/vmmon/phystrack.h            |   49 +
 drivers/vmware/vmmon/pshare_ext.h           |  177 +
 drivers/vmware/vmmon/rateconv.h             |  141 +
 drivers/vmware/vmmon/speaker_reg.h          |   51 +
 drivers/vmware/vmmon/task.c                 | 2237 ++++++
 drivers/vmware/vmmon/task.h                 |   40 +
 drivers/vmware/vmmon/uccostTable.h          |   37 +
 drivers/vmware/vmmon/vcpuid.h               |   53 +
 drivers/vmware/vmmon/vcpuset.h              |  332 +
 drivers/vmware/vmmon/versioned_atomic.h     |  142 +
 drivers/vmware/vmmon/vm_asm.h               |   76 +
 drivers/vmware/vmmon/vm_asm_x86.h           |  964 +++
 drivers/vmware/vmmon/vm_asm_x86_64.h        |  119 +
 drivers/vmware/vmmon/vm_assert.h            |  308 +
 drivers/vmware/vmmon/vm_atomic.h            | 2049 ++++++
 drivers/vmware/vmmon/vm_basic_asm.h         |  832 +++
 drivers/vmware/vmmon/vm_basic_asm_x86.h     |  500 ++
 drivers/vmware/vmmon/vm_basic_asm_x86_64.h  |  336 +
 drivers/vmware/vmmon/vm_basic_defs.h        |  553 ++
 drivers/vmware/vmmon/vm_basic_math.h        |   67 +
 drivers/vmware/vmmon/vm_basic_types.h       |  847 +++
 drivers/vmware/vmmon/vm_time.h              |  114 +
 drivers/vmware/vmmon/vmhost.h               |  110 +
 drivers/vmware/vmmon/vmm_constants.h        |   51 +
 drivers/vmware/vmmon/vmmonInt.h             |   77 +
 drivers/vmware/vmmon/vmware.h               |   58 +
 drivers/vmware/vmmon/vmware_pack_begin.h    |   43 +
 drivers/vmware/vmmon/vmware_pack_end.h      |   44 +
 drivers/vmware/vmmon/vmware_pack_init.h     |   65 +
 drivers/vmware/vmmon/vmx86.c                | 3043 ++++++++
 drivers/vmware/vmmon/vmx86.h                |  200 +
 drivers/vmware/vmmon/x86.h                  |   44 +
 drivers/vmware/vmmon/x86_basic_defs.h       |  221 +
 drivers/vmware/vmmon/x86apic.h              |  301 +
 drivers/vmware/vmmon/x86cpuid.h             |  827 +++
 drivers/vmware/vmmon/x86desc.h              |  623 ++
 drivers/vmware/vmmon/x86fpu.h               |  389 ++
 drivers/vmware/vmmon/x86msr.h               |  236 +
 drivers/vmware/vmmon/x86paging.h            |  247 +
 drivers/vmware/vmmon/x86regname.h           |   94 +
 drivers/vmware/vmmon/x86segdescrs.h         |  113 +
 drivers/vmware/vmmon/x86sel.h               |   68 +
 drivers/vmware/vmmon/x86svm.h               |  335 +
 drivers/vmware/vmmon/x86types.h             |  532 ++
 drivers/vmware/vmmon/x86vt.h                |  623 ++
 drivers/vmware/vmnet/Makefile               |   14 +
 drivers/vmware/vmnet/bridge.c               | 1640 +++++
 drivers/vmware/vmnet/compat_file.h          |   56 +
 drivers/vmware/vmnet/compat_highmem.h       |   40 +
 drivers/vmware/vmnet/compat_kdev_t.h        |   33 +
 drivers/vmware/vmnet/compat_mm.h            |  134 +
 drivers/vmware/vmnet/compat_module.h        |   72 +
 drivers/vmware/vmnet/compat_netdevice.h     |  287 +
 drivers/vmware/vmnet/compat_page.h          |   75 +
 drivers/vmware/vmnet/compat_pgtable.h       |  139 +
 drivers/vmware/vmnet/compat_sched.h         |  274 +
 drivers/vmware/vmnet/compat_semaphore.h     |   44 +
 drivers/vmware/vmnet/compat_skbuff.h        |  156 +
 drivers/vmware/vmnet/compat_slab.h          |   70 +
 drivers/vmware/vmnet/compat_sock.h          |  169 +
 drivers/vmware/vmnet/compat_spinlock.h      |   68 +
 drivers/vmware/vmnet/compat_uaccess.h       |   79 +
 drivers/vmware/vmnet/compat_version.h       |  121 +
 drivers/vmware/vmnet/compat_wait.h          |  225 +
 drivers/vmware/vmnet/driver-config.h        |   78 +
 drivers/vmware/vmnet/driver.c               | 1842 +++++
 drivers/vmware/vmnet/epoll.c                |   36 +
 drivers/vmware/vmnet/filter.c               | 1540 ++++
 drivers/vmware/vmnet/geninclude.c           |   40 +
 drivers/vmware/vmnet/hub.c                  |  741 ++
 drivers/vmware/vmnet/includeCheck.h         |   17 +
 drivers/vmware/vmnet/net.h                  |   75 +
 drivers/vmware/vmnet/netdev_has_dev_net.c   |   37 +
 drivers/vmware/vmnet/netdev_has_net.c       |   43 +
 drivers/vmware/vmnet/netif.c                |  723 ++
 drivers/vmware/vmnet/nfhook_uses_skb.c      |   45 +
 drivers/vmware/vmnet/pgtbl.h                |  381 +
 drivers/vmware/vmnet/procfs.c               |  402 ++
 drivers/vmware/vmnet/setnice.c              |   32 +
 drivers/vmware/vmnet/sk_alloc.c             |   39 +
 drivers/vmware/vmnet/skblin.c               |   41 +
 drivers/vmware/vmnet/smac.c                 | 3792 ++++++++++
 drivers/vmware/vmnet/smac.h                 |  109 +
 drivers/vmware/vmnet/smac_compat.c          |  524 ++
 drivers/vmware/vmnet/smac_compat.h          |   63 +
 drivers/vmware/vmnet/socket.c               |   33 +
 drivers/vmware/vmnet/userif.c               | 1057 +++
 drivers/vmware/vmnet/vm_atomic.h            | 2049 ++++++
 drivers/vmware/vmnet/vm_basic_asm.h         |  832 +++
 drivers/vmware/vmnet/vm_basic_asm_x86.h     |  500 ++
 drivers/vmware/vmnet/vm_basic_asm_x86_64.h  |  336 +
 drivers/vmware/vmnet/vm_basic_defs.h        |  553 ++
 drivers/vmware/vmnet/vm_basic_types.h       |  847 +++
 drivers/vmware/vmnet/vm_device_version.h    |  185 +
 drivers/vmware/vmnet/vm_oui.h               |  177 +
 drivers/vmware/vmnet/vmnetInt.h             |  169 +
 drivers/vmware/vmnet/vmware_pack_begin.h    |   43 +
 drivers/vmware/vmnet/vmware_pack_end.h      |   44 +
 drivers/vmware/vmnet/vmware_pack_init.h     |   65 +
 drivers/vmware/vmnet/vnet.h                 |  415 ++
 drivers/vmware/vmnet/vnetEvent.c            |  549 ++
 drivers/vmware/vmnet/vnetEvent.h            |   50 +
 drivers/vmware/vmnet/vnetFilter.h           |  207 +
 drivers/vmware/vmnet/vnetFilterInt.h        |   75 +
 drivers/vmware/vmnet/vnetInt.h              |  351 +
 drivers/vmware/vmnet/vnetKernel.h           |   85 +
 drivers/vmware/vmnet/vnetUserListener.c     |  333 +
 drivers/vmware/vmnet/x86cpuid.h             |  827 +++
 fs/Kconfig                                  |    9 +
 fs/Makefile                                 |    1 +
 fs/novfs/Makefile                           |   19 +
 fs/novfs/commands.h                         |  955 +++
 fs/novfs/daemon.c                           | 2125 ++++++
 fs/novfs/file.c                             | 1983 ++++++
 fs/novfs/inode.c                            | 4742 +++++++++++++
 fs/novfs/nwcapi.c                           | 2236 ++++++
 fs/novfs/nwcapi.h                           | 1416 ++++
 fs/novfs/nwerror.h                          |  658 ++
 fs/novfs/proc.c                             |  153 +
 fs/novfs/profile.c                          |  710 ++
 fs/novfs/scope.c                            |  659 ++
 fs/novfs/vfs.h                              |  453 ++
 include/linux/bitmap.h                      |    1 +
 include/linux/byteorder/bitfields.h         |  114 +
 include/linux/usb.h                         |    3 +
 include/linux/usb/wusb-wa.h                 |  281 +
 include/linux/usb/wusb.h                    |  419 ++
 include/linux/uwb.h                         |  759 ++
 include/linux/uwb/debug-cmd.h               |   57 +
 include/linux/uwb/debug.h                   |   82 +
 include/linux/uwb/spec.h                    |  625 ++
 include/linux/uwb/umc.h                     |  194 +
 include/linux/uwb/whci.h                    |  117 +
 include/linux/wlp.h                         |  728 ++
 lib/bitmap.c                                |   22 +
 508 files changed, 230776 insertions(+), 646 deletions(-)

---------------

Anderson Lizardo (3):
      WUSB: fix error path for wusb_set_dev_addr()
      uwb: disable command/event filtering for D-Link DUB-1210
      UWB: add Intel i1480 HWA to the UWB RC quirk table

Andrew Morton (1):
      WUSB: drivers/uwb/wlp/sysfs.c: move misplaced debug statement

Brandon Philips (1):
      aectc: add the aectc driver

David Vrabel (9):
      bitmap: add bitmap_copy_le()
      uwb: add the UWB stack (reservation manager)
      uwb: add the UWB stack (debug support)
      uwb: add the umc bus
      uwb: add the driver to enumerate WHCI capabilities
      wusb: WHCI host controller driver
      UWB: fix oops in uwbd_dev_offair()
      UWB: fix oops when notifying of BG joining/leaving
      UWB: make UWB selectable on all archs with USB support

Dean Anderson (1):
      USB: add Sensoray 2255 v4l driver

Greg Kroah-Hartman (24):
      USB: add option hso driver
      Input: add appleir driver
      DVB: add firesat driver
      Video: add the go7007 driver
      NET: add Alacritech slicoss driver
      me4000 firmware file
      me4000: add pci data collection driver
      novfs: Add the Novell filesystem client kernel module
      novfs: port the novfs 3.0 fixes to mainline
      NET: add et131x driver
      Framebuffer: add the VIA framebuffer driver
      OMS: add OMS MAXp driver
      via: add support for new via_chrome9 driver
      via: codingstyle cleanpus for via drm drivers
      USB: add USB test and measurement class driver
      kolter_1616: add kolter_1616 PCI I/O driver
      input: add mimio xi driver
      uwb: add the UWB stack (build system)
      uwb: add WiMedia LLC Protocol (build system)
      wusb: add the Wireless USB core (build-system)
      add drivers/vmware to the build
      vmware: add vmblock driver
      vmware: add vmnet driver
      vmware: add vmmon driver

Inaky Perez-Gonzalez (18):
      Add helper macros for little-endian bitfields
      USB: add usb_dev_reset_delayed
      uwb: add initial documentation
      uwb: add the uwb include files
      uwb: add the UWB stack (core files)
      uwb: add the UWB stack (radio controller interface)
      uwb: add the UWB stack (MLME)
      uwb: add whc-rc radio control driver
      uwb: add hwa-rc radio controller driver
      uwb: add the i1480 DFU driver
      uwb: add the i1480 WLP driver
      wusb: add the Wireless USB include files.
      wusb: add the Wireless USB core
      wusb: add the Wireless USB core (protocol)
      wusb: add the Wireless WUSB core (security)
      wusb: add the USB wusb-cbaf driver
      wusb: add the Wire Adapter (WA) core
      wusb: add hwa-hc wireless host controller driver

Randy Dunlap (1):
      uwb: fix Kconfig causing undefined references

Reinette Chatre (3):
      uwb: add the WiMedia LLC Protocol stack
      uwb: add WiMedia LLC Protocol stack (messages)
      uwb: add WiMedia LLC Protocol stack (WSS)

