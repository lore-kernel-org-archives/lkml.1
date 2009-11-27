Return-Path: <linux-kernel-owner+w=401wt.eu-S1752153AbZK0U4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbZK0U4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 15:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbZK0U4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 15:56:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbZK0U4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 15:56:05 -0500
Message-ID: <4B103CE1.8050303@redhat.com>
Date: Fri, 27 Nov 2009 18:56:01 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
Subject: [GIT PULL for 2.6.32] V4L/DVB updates
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For the following drivers and building fixes:

   - radio-gemtek-pci: fix double mutex_lock
   - v4l: add more missing linux/sched.h includes
   - soc-camera: properly initialise the device object when reusing
   - soc-camera: sh_mobile_ceu_camera: call pm_runtime_disable
   - em28xx: fix Reddo DVB-C USB TV Box GPIO
   - davinci: remove stray duplicate config pointer
   - SMS_SIANO_MDTV should depend on HAS_DMA
   - cxusb: Fix hang on DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1)
   - sh_mobile_ceu_camera: fix compile warning
   - Fix wrong parameter order in memset

I'm adding on this series an update at MAINTAINERS for a driver
that were already added for 2.6.32: the gspca_gl860 driver.

Cheers,
Mauro.

---

 MAINTAINERS                                |    7 +++++++
 drivers/media/common/ir-functions.c        |    2 +-
 drivers/media/dvb/dvb-usb/cxusb.c          |   10 +++++++++-
 drivers/media/dvb/siano/Kconfig            |    2 +-
 drivers/media/radio/radio-gemtek-pci.c     |    2 --
 drivers/media/video/davinci/vpif_display.c |    1 -
 drivers/media/video/em28xx/em28xx-cards.c  |    2 +-
 drivers/media/video/mx1_camera.c           |    1 +
 drivers/media/video/mx3_camera.c           |    1 +
 drivers/media/video/sh_mobile_ceu_camera.c |    7 +++++--
 drivers/media/video/soc_camera.c           |   17 ++++++++++++-----
 drivers/media/video/videobuf-dma-contig.c  |    1 +
 12 files changed, 39 insertions(+), 14 deletions(-)

Alan Cox (1):
      V4L/DVB (13530): Fix wrong parameter order in memset

Antti Palosaari (1):
      V4L/DVB (13366): em28xx: fix Reddo DVB-C USB TV Box GPIO

Geert Uytterhoeven (1):
      V4L/DVB (13412): SMS_SIANO_MDTV should depend on HAS_DMA

Guennadi Liakhovetski (2):
      V4L/DVB (13343): v4l: add more missing linux/sched.h includes
      V4L/DVB (13344): soc-camera: properly initialise the device object when reusing

Hans Verkuil (3):
      V4L/DVB (13321): radio-gemtek-pci: fix double mutex_lock
      V4L/DVB (13371): davinci: remove stray duplicate config pointer
      V4L/DVB (13481): sh_mobile_ceu_camera: fix compile warning

Kuninori Morimoto (1):
      V4L/DVB (13345): soc-camera: sh_mobile_ceu_camera: call pm_runtime_disable

Olivier Lorin (1):
      V4L/DVB (13372a): MAINTAINERS: addition of gspca_gl860 driver

Robert Lowery (1):
      V4L/DVB (13436): cxusb: Fix hang on DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1)

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
