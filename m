Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbYDFUGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbYDFUGj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 16:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbYDFUGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 16:06:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59826 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYDFUG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 16:06:29 -0400
Date: Sun, 6 Apr 2008 17:06:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes for 2.6.25-rc8
Message-ID: <20080406170601.7c8f9711@gaivota>
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

   - bttv: Bt832 - fix possible NULL pointer deref
   - s5h1409: fix blown-away bit in function s5h1409_set_gpio
   - v4l/dvb Kconfig: Fix bugzilla #10067

Cheers,
Mauro.

---

 drivers/media/Makefile                |    3 +++
 drivers/media/dvb/frontends/s5h1409.c |    2 +-
 drivers/media/video/bt8xx/bt832.c     |   12 +++++++++++-
 3 files changed, 15 insertions(+), 2 deletions(-)

Cyrill Gorcunov (1):
      V4L/DVB (7460): bttv: Bt832 - fix possible NULL pointer deref

Mauro Carvalho Chehab (1):
      V4L/DVB (7499): v4l/dvb Kconfig: Fix bugzilla #10067

Michael Krufky (1):
      V4L/DVB (7495): s5h1409: fix blown-away bit in function s5h1409_set_gpio

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
