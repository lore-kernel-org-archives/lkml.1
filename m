Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbYHGB1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbYHGB1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 21:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbYHGB1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 21:27:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40946 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbYHGB1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 21:27:04 -0400
Date: Wed, 6 Aug 2008 22:26:32 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES for 2.6.27] V4L/DVB fixes
Message-ID: <20080806222632.0473ce07@gaivota.chehab.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
 ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git for_linus

For the following:

   - a docbook fix;
   - several fixes on the new gspca driver;
   - a typo fix at Kconfig;
   - some Kbuild fixes;
   - a few driver fixes on em28xx, cxusb, soc_camera, pxa_camera and uvc;

Cheers,
Mauro.

---

 Documentation/video4linux/gspca.txt        |    1 +
 drivers/media/dvb/dvb-usb/cxusb.c          |    7 +-
 drivers/media/dvb/frontends/Kconfig        |    3 +-
 drivers/media/video/Kconfig                |    2 +-
 drivers/media/video/arv.c                  |    2 +-
 drivers/media/video/em28xx/em28xx-cards.c  |    1 +
 drivers/media/video/gspca/conex.c          |    4 +-
 drivers/media/video/gspca/etoms.c          |  137 +++++----
 drivers/media/video/gspca/gspca.c          |   12 +-
 drivers/media/video/gspca/gspca.h          |    5 +-
 drivers/media/video/gspca/ov519.c          |  476 +++++++++++++---------------
 drivers/media/video/gspca/pac7311.c        |   54 ++--
 drivers/media/video/gspca/sonixb.c         |    2 +-
 drivers/media/video/gspca/sonixj.c         |  287 +++++++----------
 drivers/media/video/gspca/spca505.c        |   12 +-
 drivers/media/video/gspca/spca506.c        |   12 +-
 drivers/media/video/gspca/spca508.c        |   18 +-
 drivers/media/video/gspca/spca561.c        |   42 ++-
 drivers/media/video/gspca/vc032x.c         |    4 +-
 drivers/media/video/gspca/zc3xx.c          |    6 +-
 drivers/media/video/pxa_camera.c           |   58 ++++-
 drivers/media/video/sh_mobile_ceu_camera.c |    2 +-
 drivers/media/video/soc_camera.c           |   26 ++
 drivers/media/video/soc_camera_platform.c  |    2 +-
 drivers/media/video/uvc/uvc_ctrl.c         |   33 ++-
 drivers/media/video/uvc/uvc_driver.c       |   26 ++-
 drivers/media/video/uvc/uvc_video.c        |   33 ++-
 drivers/media/video/v4l2-dev.c             |    4 +-
 drivers/media/video/vino.c                 |    2 +-
 include/media/soc_camera.h                 |    5 +
 30 files changed, 685 insertions(+), 593 deletions(-)

Adrian Bunk (2):
      V4L/DVB (8562): DVB_DRX397XD: remove FW_LOADER select
      V4L/DVB (8563): fix drivers/media/video/arv.c compilation

Eugeniy Meshcheryakov (1):
      V4L/DVB (8582): set mts_firmware for em2882 based Pinnacle Hybrid Pro

Jean-Francois Moine (10):
      V4L/DVB (8550): gspca: Change a bit the init of ov7660 and Sonix JPEG
bridges. V4L/DVB (8552): gspca: Bad pixel format in the spca508 subdriver.
      V4L/DVB (8567): gspca: hflip and vflip controls added for ov519 - ov7670
plus init cleanup. V4L/DVB (8569): gspca: Set back the old values of Sonix
sn9c120 and cleanup source. V4L/DVB (8571): gspca: Don't use
CONFIG_VIDEO_ADV_DEBUG as a compile option. V4L/DVB (8572): gspca: Webcam
0c45:6143 in documentation. V4L/DVB (8573): gspca: Bad scan of frame in
spca505/506/508. V4L/DVB (8574): gspca: Bad bytesperlines of pixelformat in
spca505/506/508 and vc023x. V4L/DVB (8602): gspca: Fix small bugs, simplify and
cleanup ov519. V4L/DVB (8604): gspca: Fix of "scheduling while atomic" crash.

Laurent Pinchart (2):
      V4L/DVB (8616): uvcvideo: Add support for two Bison Electronics webcams
      V4L/DVB (8617): uvcvideo: don't use stack-based buffers for USB transfers.

Mauro Carvalho Chehab (2):
      V4L/DVB (8558): media/video/Kconfig: fix a typo
      V4L/DVB (8628a): Remove duplicated include

Paul Mundt (1):
      V4L/DVB (8609): media: Clean up platform_driver_unregister() bogosity.

Rabin Vincent (1):
      V4L/DVB (8605): gspca: Fix of gspca_zc3xx oops - 2.6.27-rc1

Randy Dunlap (1):
      V4L/DVB (8549a): fix kernel-doc warning, function name, and docbook
filename

Robert Jarzmik (2):
      V4L/DVB (8610): Add suspend/resume capabilities to soc_camera.
      V4L/DVB (8611): Add suspend/resume to pxa_camera driver

Robert Lowery (1):
      V4L/DVB (8607): cxusb: fix OOPS and broken tuning regression on
FusionHDTV Dual Digital 4

Yoichi Yuasa (1):
      V4L/DVB (8564): fix vino driver build error

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
