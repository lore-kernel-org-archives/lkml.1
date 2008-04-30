Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbYD3D3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbYD3D3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 23:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYD3D3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 23:29:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44470 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbYD3D3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 23:29:07 -0400
Date: Wed, 30 Apr 2008 00:27:46 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes for 2.6.26
Message-ID: <20080430002746.393e68e9@gaivota>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
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

For the following trivial fixes:

   - Fix merge conflicts on Kconfig items;
   - two small fixes on ivtv;
   - a warning fix at cx88;
   - tuners/Kconfig: Change config name and help to reflect dynamic load for 
     tuners.

Cheers,
Mauro.

---

 drivers/media/common/tuners/Kconfig     |    9 +++++++--
 drivers/media/video/cx18/Kconfig        |    2 +-
 drivers/media/video/cx18/cx18-driver.c  |    2 +-
 drivers/media/video/cx88/cx88-i2c.c     |    1 -
 drivers/media/video/ivtv/ivtv-driver.c  |    6 +++---
 drivers/media/video/ivtv/ivtv-fileops.c |    4 +++-
 drivers/media/video/tuner-core.c        |    2 +-
 7 files changed, 16 insertions(+), 10 deletions(-)

Hans Verkuil (1):
      V4L/DVB (7791): ivtv: POLLHUP must be returned on eof

Mauro Carvalho Chehab (3):
      V4L/DVB (7789b): Fix merge conflicts
      V4L/DVB (7794): cx88: Fix a warning
      V4L/DVB (7798): tuners/Kconfig: Change config name and help to reflect dynamic load for tuners

Robert P. J. Day (1):
      V4L/DVB (7792): ivtv: correct misspelled "HIMEM4G" to "HIGHMEM4G" in error message

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
