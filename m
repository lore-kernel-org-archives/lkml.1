Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbYCTPSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbYCTPSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 11:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbYCTPSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 11:18:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51502 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbYCTPSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 11:18:23 -0400
Date: Thu, 20 Mar 2008 12:18:07 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB updates
Message-ID: <20080320121807.7af35d4b@gaivota>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
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
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

For the following:

   - saa7134: fix FM radio support for the Pinnacle PCTV 110i
   - bttv: struct member initialized twice
   - ivtv: fix for yuv filter table check
   - VIDEO_VIVI must depend on VIDEO_DEV
   - cx88: Fix: Loads tuner module before sending commands to it
   - saa7134: fix: tuner should be loaded before calling saa7134_board_init2()
   - ivtv: Add missing sg_init_table()
   - em28xx: Correct use of ! and &
   - em28xx: correct use of and fix
   - usb/opera1.c: fix a memory leak
   - V4L1 - fix v4l_compat_translate_ioctl possible NULL deref
   - usb video: add a device link to usbvideo devices, else hal will ignore them
   - tvp5150.c: logical-bitwise and confusion
   - bug #10211: Fix depencencies for cx2341x

Cheers,
Mauro.

---

 drivers/media/dvb/dvb-usb/opera1.c          |    2 +-
 drivers/media/video/Kconfig                 |    4 +-
 drivers/media/video/bt8xx/bttv-driver.c     |    1 -
 drivers/media/video/cx88/cx88-cards.c       |    5 +++
 drivers/media/video/cx88/cx88-video.c       |    2 -
 drivers/media/video/em28xx/em28xx-core.c    |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c      |    7 ++--
 drivers/media/video/ivtv/ivtv-firmware.c    |    8 +++-
 drivers/media/video/saa7134/saa7134-cards.c |   41 +++++++++++-----------
 drivers/media/video/saa7134/saa7134-core.c  |    5 ++-
 drivers/media/video/tvp5150.c               |    4 +-
 drivers/media/video/usbvideo/usbvideo.c     |    9 +++--
 drivers/media/video/v4l1-compat.c           |   50 ++++++++++++++++++++++-----
 13 files changed, 90 insertions(+), 50 deletions(-)

Adrian Bunk (2):
      V4L/DVB (7251): VIDEO_VIVI must depend on VIDEO_DEV
      V4L/DVB (7328): usb/opera1.c: fix a memory leak

Andrew Morton (1):
      V4L/DVB (7291): em28xx: correct use of and fix

Cyrill Gorcunov (1):
      V4L/DVB (7330): V4L1 - fix v4l_compat_translate_ioctl possible NULL deref

Harvey Harrison (1):
      V4L/DVB (7236): bttv: struct member initialized twice

Ian Armstrong (2):
      V4L/DVB (7242): ivtv: fix for yuv filter table check
      V4L/DVB (7279): ivtv: Add missing sg_init_table()

Julia Lawall (1):
      V4L/DVB (7285): em28xx: Correct use of ! and &

Mauro Carvalho Chehab (3):
      V4L/DVB (7267): cx88: Fix: Loads tuner module before sending commands to it
      V4L/DVB (7268): saa7134: fix: tuner should be loaded before calling saa7134_board_init2()
      V4L/DVB (7367): bug #10211: Fix depencencies for cx2341x

Pascal Terjan (1):
      V4L/DVB (7334): usb video: add a device link to usbvideo devices, else hal will ignore them

Roel Kluin (1):
      V4L/DVB (7362): tvp5150.c: logical-bitwise and confusion

Yuri Funduryan (1):
      V4L/DVB (7228): saa7134: fix FM radio support for the Pinnacle PCTV 110i

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
