Return-Path: <linux-kernel-owner+w=401wt.eu-S1762514AbYAKVnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762514AbYAKVnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 16:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761035AbYAKVnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 16:43:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54404 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760945AbYAKVnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 16:43:05 -0500
Date: Fri, 11 Jan 2008 19:42:41 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes
Message-ID: <20080111194241.16de1e88@gaivota>
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

For two driver fixes:

   - ivtv: There are reports of regressions, due to udelay=5 on other 
     ivtv boards. Better to be convervative than to break devices. so, 
     stick to udelay=10 for all boards;

   - av7110: fix section mismatch.

Cheers,
Mauro.

---

 drivers/media/dvb/ttpci/av7110.c       |   10 +++++-----
 drivers/media/video/ivtv/ivtv-driver.c |    4 ----
 2 files changed, 5 insertions(+), 9 deletions(-)

Hans Verkuil (1):
      V4L/DVB (6999): ivtv: stick to udelay=10 after all

Randy Dunlap (1):
      V4L/DVB (7001): av7110: fix section mismatch

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
