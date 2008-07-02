Return-Path: <linux-kernel-owner+w=401wt.eu-S1762917AbYGBMTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762917AbYGBMTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 08:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbYGBMSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 08:18:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47527 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbYGBMSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 08:18:49 -0400
Date: Wed, 2 Jul 2008 09:18:19 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Brandon Philips <bphilips@suse.de>
Subject: Re: [GIT PATCH for 2.6.26] V4L/DVB: Addition of UVC driver
Message-ID: <20080702091819.031ea3ad@gaivota>
In-Reply-To: <20080630175605.445b7672@gaivota>
References: <20080630175605.445b7672@gaivota>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008 17:56:05 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> Linus,
> 
> Please pull from:
>         ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master
> 
> For USB Video Class (UVC) driver.
> 
> I know that we are very late on 2.6.26 cycle. However,
> 	1) most of modern webcams are based on USB Video Class (UVC). So, this
> driver is important to suport those cams.
> 	2) This is a driver-only addition. There aren't any changes at V4L/DVB
> core. No risk of causing regressions on the already supported devices;
> 	3) The driver were already reviewed by V4L and USB people;
> 	4) The driver is already widely used, since it is merged as an
> out-of-tree driver on several distros. 
> 
> So, on my opinion, we should merge it for 2.6.26.

I got a small but relevant bug at uvc Makefile.

If you decide to apply it, please merge those two patches:

   - USB Video Class driver
   - uvc: Fix compilation breakage for the other drivers, if uvc is selected

So, please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

 MAINTAINERS                          |    8 +
 drivers/media/video/Kconfig          |    8 +
 drivers/media/video/Makefile         |    2 +
 drivers/media/video/uvc/Makefile     |    3 +
 drivers/media/video/uvc/uvc_ctrl.c   | 1256 ++++++++++++++++++++++
 drivers/media/video/uvc/uvc_driver.c | 1955 ++++++++++++++++++++++++++++++++++
 drivers/media/video/uvc/uvc_isight.c |  134 +++
 drivers/media/video/uvc/uvc_queue.c  |  477 +++++++++
 drivers/media/video/uvc/uvc_status.c |  207 ++++
 drivers/media/video/uvc/uvc_v4l2.c   | 1105 +++++++++++++++++++
 drivers/media/video/uvc/uvc_video.c  |  934 ++++++++++++++++
 drivers/media/video/uvc/uvcvideo.h   |  796 ++++++++++++++
 12 files changed, 6885 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/uvc/Makefile
 create mode 100644 drivers/media/video/uvc/uvc_ctrl.c
 create mode 100644 drivers/media/video/uvc/uvc_driver.c
 create mode 100644 drivers/media/video/uvc/uvc_isight.c
 create mode 100644 drivers/media/video/uvc/uvc_queue.c
 create mode 100644 drivers/media/video/uvc/uvc_status.c
 create mode 100644 drivers/media/video/uvc/uvc_v4l2.c
 create mode 100644 drivers/media/video/uvc/uvc_video.c
 create mode 100644 drivers/media/video/uvc/uvcvideo.h

Laurent Pinchart (1):
      V4L/DVB (8145a): USB Video Class driver

Mauro Carvalho Chehab (1):
      V4L/DVB (8178): uvc: Fix compilation breakage for the other drivers, if uvc is selected

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org


Cheers,
Mauro
