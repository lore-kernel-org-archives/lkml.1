Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbYFUIwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbYFUIwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 04:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYFUIwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 04:52:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50246 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbYFUIwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 04:52:10 -0400
Date: Sat, 21 Jun 2008 01:50:54 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: linux-staging for 2.6.26-rc7
Message-ID: <20080621085054.GA12224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the announcement for the linux-staging tree for 2.6.26-rc7.

It currently contains 15 drivers and one filesystem.

It can be downloaded from:
	http://www.kernel.org/pub/linux/kernel/people/gregkh/linux-staging/linux-staging-2.6.26-rc7.bz2

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
 drivers/input/misc/Kconfig                  |   12 +
 drivers/input/misc/Makefile                 |    1 +
 drivers/input/misc/appleir.c                |  361 +
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
 drivers/usb/class/Kconfig                   |   10 +
 drivers/usb/class/Makefile                  |    1 +
 drivers/usb/class/usbtmc.c                  | 1576 +++++
 drivers/usb/class/usbtmc.h                  |  144 +
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
 193 files changed, 130180 insertions(+), 646 deletions(-)

---------------

Brandon Philips (1):
      aectc: add the aectc driver

Dean Anderson (1):
      USB: add Sensoray 2255 v4l driver

Greg Kroah-Hartman (16):
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

