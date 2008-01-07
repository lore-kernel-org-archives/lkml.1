Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbYAGJip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbYAGJip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 04:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbYAGJih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 04:38:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57959 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbYAGJig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 04:38:36 -0500
Date: Mon, 7 Jan 2008 07:38:18 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes
Message-ID: <20080107073818.368243b9@gaivota>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
master

For two driver regression fixes:
   - bttv: VIDIOCGMBUF ioctl hangs on bttv driver
   - ivtv: udelay has to be changed *after* the eeprom was read, not before

Cheers,
Mauro.

---

 drivers/media/video/bt8xx/bttv-driver.c |    4 +---
 drivers/media/video/ivtv/ivtv-driver.c  |    4 ++++
 drivers/media/video/ivtv/ivtv-i2c.c     |    5 +----
 3 files changed, 6 insertions(+), 7 deletions(-)

Gregor Jasny (1):
      V4L/DVB (6944a): Fix Regression VIDIOCGMBUF ioctl hangs on bttv driver

Hans Verkuil (1):
      V4L/DVB (6916): ivtv: udelay has to be changed *after* the eeprom was
read, not before

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
