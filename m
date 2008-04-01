Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbYDAWvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbYDAWvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 18:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbYDAWvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 18:51:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46714 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbYDAWvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 18:51:44 -0400
Date: Tue, 1 Apr 2008 19:50:50 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes for 2.6.25-rc8
Message-ID: <20080401195050.470c8edb@gaivota>
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

For the following fixes and regressions:
	- bttv fixes for bugzilla regressions #10027 and #10364;
	- cx23885 fixes for some regressions;
	- add missing MODULE_LICENSE to v4l2-int-device;
	- radio-cadet compilation fixes for PNP probe code.

One of the changes of cx23885 is bigger, since it simplified the on-chip memory
usage.

All changes are trivial.

Cheers,
Mauro.

---

 drivers/media/radio/radio-cadet.c           |    6 +
 drivers/media/video/bt8xx/bttv-driver.c     |   31 +++++--
 drivers/media/video/cx23885/cx23885-cards.c |    6 +-
 drivers/media/video/cx23885/cx23885-core.c  |  134 +--------------------------
 drivers/media/video/v4l2-int-device.c       |    2 +
 5 files changed, 38 insertions(+), 141 deletions(-)

Adrian Bunk (1):
      V4L/DVB (7485): v4l2-int-device.c: add MODULE_LICENSE

Bjorn Helgaas (1):
      V4L/DVB (7486): radio-cadet: wrap PNP probe code in #ifdef CONFIG_PNP

Cyrill Gorcunov (1):
      V4L/DVB (7461): bttv: fix missed index check

Robert Fitzsimons (3):
      V4L/DVB (7277): bttv: Re-enabling radio support requires the use of struct bttv_fh
      V4L/DVB (7278): bttv: Re-enable radio tuner support for VIDIOCGFREQ/VIDIOCSFREQ ioctls
      V4L/DVB (7400): bttv: Add a radio compat_ioctl file operation

Steven Toth (3):
      V4L/DVB (7464): Convert driver to use a single SRAM memory map
      V4L/DVB (7465): Fix eeprom parsing and errors on the HVR1800 products
      V4L/DVB (7466): Avoid minor model number warning when an OEM HVR1250 board is detected

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
