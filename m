Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab0BSFba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 00:31:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab0BSFb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 00:31:28 -0500
Message-ID: <4B7E2219.2030606@redhat.com>
Date: Fri, 19 Feb 2010 03:31:05 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: linus torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL for 2.6.33-rc8] Some bug and regression fixes for V4L/DVB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f8b55f251012e104093e105483c45c5d85ad3040:
  Christine Caulfield (1):
        Orphan DECnet

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Ben Hutchings (1):
      V4L/DVB: cxusb: Select all required frontend and tuner modules

Jean Delvare (1):
      V4L/DVB: bttv: Move I2C IR initialization

Kuninori Morimoto (1):
      soc-camera: mt9t112: modify exiting conditions from standby mode

Martin Fuzzey (1):
      V4L/DVB: Video : pwc : Fix regression in pwc_set_shutter_speed caused by bad 	constant => sizeof conversion.

Richard Guenther (1):
      V4L/DVB: dvb: l64781.ko broken with gcc 4.5

 drivers/media/dvb/dvb-usb/Kconfig       |    4 +++-
 drivers/media/dvb/frontends/l64781.c    |    4 ++--
 drivers/media/video/bt8xx/bttv-driver.c |    1 +
 drivers/media/video/bt8xx/bttv-i2c.c    |    8 ++++++--
 drivers/media/video/bt8xx/bttvp.h       |    1 +
 drivers/media/video/mt9t112.c           |    2 +-
 drivers/media/video/pwc/pwc-ctrl.c      |    2 +-
 7 files changed, 15 insertions(+), 7 deletions(-)

-- 

Cheers,
Mauro
