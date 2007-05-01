Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbXEASEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbXEASEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbXEASEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:04:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50600 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbXEASE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:04:29 -0400
Date: Tue, 01 May 2007 14:40:52 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB updates
Message-Id: <1178042628.11109.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

This series contains a few fixes and cleanups, including a compilation fix for alpha
architecture:

   - Cx88: fix compilation on alpha
   - MEDIA: Spinlock initializer cleanup
   - Cx88-mpeg.c: make 2 functions static
   - VIDIOCGMBUF handling in video_ioctl2()
   - Fix: v4l1_compat should be called only if V4L1_COMPAT
   - V4l1-compat: misc fixes for pixelformat function
   - V4l1-compat:  Make VIDIOCSPICT return errors in a useful way
   - Pvrusb2: use mutex instead of semaphore
   - Pvrusb2: kill unnecessary attribute->owner
   - Pvrusb2: Improve handling of PAL-60 video standard
   - Pvrusb2: Implement ability to disable IR receiver
   - Improve / fix support for PAL-60 in cx25840
   - Workaround for bad hardare/firmware on some pluto2 devices

Cheers,
Mauro.

---

 drivers/media/dvb/pluto2/pluto2.c              |    8 +++
 drivers/media/video/cx25840/cx25840-core.c     |    4 +-
 drivers/media/video/cx88/cx88-alsa.c           |    1 +
 drivers/media/video/cx88/cx88-mpeg.c           |    5 +-
 drivers/media/video/cx88/cx88-video.c          |    1 +
 drivers/media/video/ivtv/ivtv-driver.c         |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-encoder.c  |   13 ++++-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c      |   10 ++--
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c |   23 ++++++++-
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c    |   14 -----
 drivers/media/video/v4l1-compat.c              |   64 +++++++++++++++++------
 drivers/media/video/videodev.c                 |   48 +++++++++++-------
 12 files changed, 130 insertions(+), 63 deletions(-)

Adrian Bunk (1):
      V4L/DVB (5567): Cx88-mpeg.c: make 2 functions static

Alexey Dobriyan (1):
      V4L/DVB (5565): Cx88: fix compilation on alpha

Matthias Kaehlcke (1):
      V4L/DVB (5572): Pvrusb2: use mutex instead of semaphore

Mauro Carvalho Chehab (1):
      V4L/DVB (5569): Fix: v4l1_compat should be called only if V4L1_COMPAT

Mike Isely (2):
      V4L/DVB (5574): Pvrusb2: Improve handling of PAL-60 video standard
      V4L/DVB (5575): Pvrusb2: Implement ability to disable IR receiver

Sam Revitch (1):
      V4L/DVB (5568): VIDIOCGMBUF handling in video_ioctl2()

Servaas Vandenberghe (1):
      V4L/DVB (5576): Improve / fix support for PAL-60 in cx25840

Tejun Heo (1):
      V4L/DVB (5573): Pvrusb2: kill unnecessary attribute->owner

Thomas Gleixner (1):
      V4L/DVB (5566): MEDIA: Spinlock initializer cleanup

Trent Piepho (2):
      V4L/DVB (5570): V4l1-compat: misc fixes for pixelformat function
      V4L/DVB (5571): V4l1-compat:  Make VIDIOCSPICT return errors in a useful way

holger@muscate-magnussen.de (1):
      V4L/DVB (5578): Workaround for bad hardare/firmware on some pluto2 devices

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

