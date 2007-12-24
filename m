Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbXLXMil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbXLXMil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 07:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbXLXMic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 07:38:32 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52172 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbXLXMib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 07:38:31 -0500
Date: Mon, 24 Dec 2007 10:37:44 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB updates
Message-ID: <20071224103744.40f39737@gaivota>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-mandriva-linux-gnu)
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

For two trivial driver fixes:
   - A fix at Kconfig to DVB_LGDT330X be selected on cx23885;
   - Some ivtv boards requres a longer i2c udelay for they to work.

Cheers,
Mauro.

---

 drivers/media/video/cx23885/Kconfig |    1 +
 drivers/media/video/ivtv/ivtv-i2c.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

Hans Verkuil (1):
      V4L/DVB (6876): ivtv: mspx4xx needs a longer i2c udelay

Michael Krufky (1):
      V4L/DVB (6871): Kconfig: VIDEO_CX23885 must select DVB_LGDT330X

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

