Return-Path: <linux-kernel-owner+w=401wt.eu-S934573AbXLMXQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934573AbXLMXQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 18:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbXLMXQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 18:16:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33670 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbXLMXQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 18:16:44 -0500
Date: Thu, 13 Dec 2007 20:45:31 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes
Message-Id: <1197587729.4864.13.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

For the following:

   - Regression fixes:
	- Fix videobuf-core locks;
	- Fix some troubles at building system.

   - Three small driver fixes, on saa7134, bt866 and s5h1409.

Cheers,
Mauro.

---

 drivers/media/Makefile                      |    2 +-
 drivers/media/dvb/frontends/s5h1409.c       |   11 ++++++++---
 drivers/media/video/bt866.c                 |    1 -
 drivers/media/video/saa7134/saa7134-cards.c |    1 +
 drivers/media/video/videobuf-core.c         |    4 ++--
 5 files changed, 12 insertions(+), 7 deletions(-)

Adrian Bunk (2):
      V4L/DVB (6803): buf-core.c locking fixes
      V4L/DVB (6814): Makefile: always enter video/

Andrew Morton (1):
      V4L/DVB (6819): i2c: fix drivers/media/video/bt866.c

Michael Krufky (1):
      V4L/DVB (6798): saa7134: enable LNA in analog mode for Hauppauge WinTV HVR-1110

Steven Toth (1):
      V4L/DVB (6820): s5h1409: QAM SNR related fixes

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

