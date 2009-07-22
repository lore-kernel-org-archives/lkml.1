Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbZGVDI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbZGVDI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 23:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbZGVDI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 23:08:28 -0400
Received: from dscas1.ad.uiuc.edu ([128.174.68.119]:4992 "EHLO
	dscas1.ad.uiuc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191AbZGVDI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 23:08:27 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jul 2009 23:08:23 EDT
From: Stoyan Gaydarov <sgayda2@uiuc.edu>
To: linux-kernel@vger.kernel.org
CC: Stoyan Gaydarov <sgayda2@uiuc.edu>
Subject: [PATCH 0/7] ARRAY_SIZE changes
Date: Tue, 21 Jul 2009 22:02:26 -0500
Message-ID: <1248231753-8344-1-git-send-email-sgayda2@uiuc.edu>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes were a direct result of using a semantic patch
More information can be found at http://www.emn.fr/x-info/coccinelle/

Stoyan Gaydarov (7):
  [staging] ARRAY_SIZE changes
  [isdn] ARRAY_SIZE changes
  [video] ARRAY_SIZE changes
  [drivers] ARRAY_SIZE changes
  [powerpc] ARRAY_SIZE changes
  [ia64] ARRAY_SIZE changes
  [cris] ARRAY_SIZE changes

 arch/cris/arch-v32/mach-a3/io.c                    |    2 +-
 arch/cris/arch-v32/mach-fs/io.c                    |    2 +-
 arch/ia64/kernel/perfmon.c                         |    2 +-
 arch/ia64/xen/xen_pv_ops.c                         |    3 +-
 arch/powerpc/platforms/pasemi/idle.c               |    2 +-
 arch/powerpc/platforms/powermac/feature.c          |    4 +-
 drivers/ata/sata_mv.c                              |    2 +-
 drivers/infiniband/hw/ipath/ipath_intr.c           |    4 +--
 drivers/isdn/act2000/capi.c                        |    2 +-
 drivers/isdn/act2000/module.c                      |    2 +-
 drivers/isdn/hardware/eicon/message.c              |    2 +-
 drivers/isdn/hardware/eicon/os_4bri.c              |    3 +-
 drivers/isdn/hisax/callc.c                         |    2 +-
 drivers/isdn/hisax/isdnl1.c                        |    6 ++--
 drivers/isdn/hisax/isdnl2.c                        |    2 +-
 drivers/isdn/hisax/isdnl3.c                        |    2 +-
 drivers/isdn/hisax/l3_1tr6.c                       |    9 ++-----
 drivers/isdn/hisax/l3dss1.c                        |   12 +++------
 drivers/isdn/hisax/l3ni1.c                         |   12 +++------
 drivers/isdn/hisax/q931.c                          |   24 ++++++++++----------
 drivers/isdn/hisax/tei.c                           |    2 +-
 drivers/media/dvb/frontends/au8522_decoder.c       |    6 +---
 drivers/media/video/gspca/conex.c                  |    2 +-
 drivers/media/video/gspca/etoms.c                  |    4 +-
 drivers/media/video/gspca/spca501.c                |    2 +-
 drivers/media/video/gspca/spca506.c                |    2 +-
 drivers/media/video/gspca/sunplus.c                |    6 ++--
 drivers/media/video/gspca/zc3xx.c                  |    2 +-
 drivers/media/video/tveeprom.c                     |    4 +-
 drivers/mtd/lpddr/qinfo_probe.c                    |    2 +-
 drivers/mtd/maps/solutionengine.c                  |    2 +-
 drivers/net/s6gmac.c                               |    2 +-
 drivers/net/wireless/prism54/oid_mgt.c             |    5 +--
 drivers/pcmcia/i82365.c                            |    2 +-
 drivers/serial/68328serial.c                       |    6 ++--
 drivers/staging/comedi/drivers/amplc_pci230.c      |    2 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |    2 +-
 drivers/staging/comedi/drivers/das08_cs.c          |    3 +-
 drivers/staging/comedi/drivers/ni_6527.c           |    2 +-
 drivers/staging/comedi/drivers/ni_65xx.c           |    2 +-
 drivers/staging/comedi/drivers/ni_660x.c           |    2 +-
 drivers/staging/comedi/drivers/ni_670x.c           |    2 +-
 drivers/staging/comedi/drivers/ni_atmio16d.c       |    2 +-
 drivers/staging/comedi/drivers/ni_pcidio.c         |    2 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         |    2 +-
 drivers/staging/comedi/drivers/pcmad.c             |    2 +-
 drivers/staging/comedi/drivers/poc.c               |    2 +-
 drivers/staging/epl/EplDllk.c                      |    2 +-
 drivers/staging/epl/proc_fs.c                      |    4 +-
 drivers/staging/line6/driver.c                     |    2 +-
 drivers/staging/meilhaus/me0600_device.h           |    2 +-
 drivers/staging/meilhaus/me0900_device.h           |    2 +-
 drivers/staging/meilhaus/me1400_device.h           |    2 +-
 drivers/staging/meilhaus/me1600_device.h           |    2 +-
 drivers/staging/meilhaus/me4600_device.h           |    2 +-
 drivers/staging/meilhaus/me6000_device.h           |    2 +-
 drivers/staging/meilhaus/me8100_device.h           |    2 +-
 drivers/staging/meilhaus/me8200_device.h           |    2 +-
 drivers/staging/meilhaus/metempl_device.h          |    2 +-
 drivers/staging/rtl8187se/r8180_wx.c               |    6 ++--
 drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c |    2 +-
 drivers/staging/rtl8192su/r8192U_wx.c              |    4 +-
 drivers/staging/slicoss/slicoss.c                  |    2 +-
 drivers/staging/sxg/sxg.c                          |    2 +-
 drivers/usb/gadget/ci13xxx_udc.c                   |    2 +-
 drivers/zorro/names.c                              |    2 +-
 66 files changed, 100 insertions(+), 119 deletions(-)

