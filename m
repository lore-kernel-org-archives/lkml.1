Return-Path: <linux-kernel-owner+w=401wt.eu-S965629AbXAXC4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965629AbXAXC4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 21:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965632AbXAXC4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 21:56:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45029 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965629AbXAXC4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 21:56:44 -0500
Message-Id: <20070124024701.PS2866700000@infradead.org>
Date: Wed, 24 Jan 2007 00:47:01 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: V4L-DVB Maintainers <v4l-dvb-maintainer@linuxtv.org>,
       V4L <video4linux-list@redhat.com>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/1] V4L/DVB fix
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1mdv2007.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull 'master' from:
        git://git.kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git 
master. 

The patch fixes an important bug on V4L core. By doing some ioctls on an 
unexpected order, it is possible to hang the machine without needing to be 
root, causing a DoS.

   - Buf_qbuf: fix: videobuf_queue->stream corruption and lockup

This patch should also be applied also at -stable releases.

Cheers,
Mauro.

V4L/DVB development is hosted at http://linuxtv.org
---

 drivers/media/video/video-buf.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

