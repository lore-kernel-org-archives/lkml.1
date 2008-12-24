Return-Path: <linux-kernel-owner+w=401wt.eu-S1752265AbYLXON6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbYLXON6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 09:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYLXONu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 09:13:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51266 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbYLXONu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 09:13:50 -0500
Date: Wed, 24 Dec 2008 12:12:52 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES for 2.6.28] V4L/DVB fixes
Message-ID: <20081224121252.7560391e@caramujo.chehab.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For a few last time driver fixes:

   - dib0700: Stop repeating after user stops pushing button
   - Cablestar 2 I2C retries (fix CableStar2 support)
   - gspca - main: Fix vidioc_s_jpegcomp locking.
   - drivers/media Kconfig fix (bugzilla #12204)
   - v4l2-compat: test for unlocked_ioctl as well.
   - MAINTAINERS: mark linux-uvc-devel as subscribers only
   - em28xx: fix NULL pointer dereference in call to VIDIOC_INT_RESET command

Cheers,
Mauro.

---

 MAINTAINERS                                 |    2 +-
 drivers/media/dvb/b2c2/Kconfig              |    2 +-
 drivers/media/dvb/b2c2/flexcop-fe-tuner.c   |    2 +
 drivers/media/dvb/b2c2/flexcop-i2c.c        |    6 +++-
 drivers/media/dvb/bt8xx/Kconfig             |    2 +-
 drivers/media/dvb/dvb-usb/Kconfig           |   46 +++++++++++++-------------
 drivers/media/dvb/dvb-usb/dib0700_devices.c |    6 ++--
 drivers/media/dvb/ttpci/Kconfig             |    2 +-
 drivers/media/video/compat_ioctl32.c        |    2 +-
 drivers/media/video/cx18/Kconfig            |    2 +-
 drivers/media/video/cx23885/Kconfig         |    4 +-
 drivers/media/video/cx88/Kconfig            |    2 +-
 drivers/media/video/em28xx/em28xx-video.c   |    3 +-
 drivers/media/video/gspca/gspca.c           |    4 +-
 drivers/media/video/pvrusb2/Kconfig         |    2 +-
 drivers/media/video/saa7134/Kconfig         |    4 +-
 16 files changed, 49 insertions(+), 42 deletions(-)


Antti Seppälä (1):
      V4L/DVB (9781): [PATCH] Cablestar 2 I2C retries (fix CableStar2 support)

Devin Heitmueller (2):
      V4L/DVB (9780): dib0700: Stop repeating after user stops pushing button
      V4L/DVB (9920): em28xx: fix NULL pointer dereference in call to VIDIOC_INT_RESET command

Hans Verkuil (1):
      V4L/DVB (9906): v4l2-compat: test for unlocked_ioctl as well.

Jim Paris (1):
      V4L/DVB (9875): gspca - main: Fix vidioc_s_jpegcomp locking.

Jiri Slaby (1):
      V4L/DVB (9908a): MAINTAINERS: mark linux-uvc-devel as subscribers only

Mauro Carvalho Chehab (1):
      V4L/DVB (9885): drivers/media Kconfig's: fix bugzilla #12204

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
