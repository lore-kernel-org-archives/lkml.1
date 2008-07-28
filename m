Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbYG1Dpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbYG1Dpw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 23:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYG1Dpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 23:45:45 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:45064 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbYG1Dpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 23:45:44 -0400
Date: Sun, 27 Jul 2008 20:42:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCHES for 2.6.27] V4L/DVB updates
Message-Id: <20080727204256.bba5eaf6.randy.dunlap@oracle.com>
In-Reply-To: <20080727224104.78b8298d@gaivota>
References: <20080727224104.78b8298d@gaivota>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jul 2008 22:41:04 -0300 Mauro Carvalho Chehab wrote:

> Linus,
> 
> Please pull from:
>         ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git for_linus
> 
> For the following:
> 
>    - API internal improvements on V4L;
>    - Two new drivers: dw2102, mxl5007t;
>    - removal of the long time broken PlanB driver;
>    - added two very old boards to be removed, at feature-removal-schedule;
>    - several fixes and new board support and cleanups on drivers: cx18, gspca,
>      uvcvideo, cs5345, cx2885, pvrusb2, em28xx, s2255drv, stkwebcam, mt20xx, anysee,
>      zr36067, saa7134, saa7134-empress, saa7146, ivtv and tveeprom and pwc;
>    - Some cleanups at V4L core.

I'd really like to get this patch that I mailed to you 2008-July-21 merged...

---

From: Randy Dunlap <randy.dunlap@oracle.com>

Add kernel-doc for parameter @index:

Warning(linhead//drivers/media/video/videodev.c:2090): No description found for parameter 'index'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/video/videodev.c |    2 ++
 1 file changed, 2 insertions(+)

--- linhead.orig/drivers/media/video/videodev.c
+++ linhead/drivers/media/video/videodev.c
@@ -2066,6 +2066,8 @@ EXPORT_SYMBOL(video_register_device);
  *	@type: type of device to register
  *	@nr:   which device number (0 == /dev/video0, 1 == /dev/video1, ...
  *             -1 == first free)
+ *	@index: stream number based on parent device;
+ *		-1 if auto assign, requested number otherwise
  *
  *	The registration code assigns minor numbers based on the type
  *	requested. -ENFILE is returned in all the device slots for this
