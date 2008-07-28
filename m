Return-Path: <linux-kernel-owner+w=401wt.eu-S1758204AbYG1SqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbYG1SqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYG1SqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:46:07 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:13469 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbYG1SqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:46:06 -0400
Date: Mon, 28 Jul 2008 11:39:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] v4l: fix kernel-doc warning, function name, and docbook
 filename
Message-Id: <20080728113938.bd84ee3c.randy.dunlap@oracle.com>
In-Reply-To: <20080728122518.77cea66e@gaivota>
References: <20080727224104.78b8298d@gaivota>
	<20080727204256.bba5eaf6.randy.dunlap@oracle.com>
	<alpine.LFD.1.10.0807280303110.18581@bombadil.infradead.org>
	<20080728081813.423ac50c.randy.dunlap@oracle.com>
	<20080728122518.77cea66e@gaivota>
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

From: Randy Dunlap <randy.dunlap@oracle.com>

Change function name in kernel-doc and add kernel-doc for parameter @index:
Warning(linhead//drivers/media/video/videodev.c:2090): No description found for parameter 'index'

Also change source file name in DocBook/videobook.tmpl to match the new
source file name.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/videobook.tmpl |    2 +-
 drivers/media/video/v4l2-dev.c       |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- head.orig/drivers/media/video/v4l2-dev.c
+++ head/drivers/media/video/v4l2-dev.c
@@ -222,11 +222,13 @@ int video_register_device(struct video_d
 EXPORT_SYMBOL(video_register_device);
 
 /**
- *	video_register_device - register video4linux devices
+ *	video_register_device_index - register video4linux devices
  *	@vfd:  video device structure we want to register
  *	@type: type of device to register
  *	@nr:   which device number (0 == /dev/video0, 1 == /dev/video1, ...
  *             -1 == first free)
+ *	@index: stream number based on parent device;
+ *		-1 if auto assign, requested number otherwise
  *
  *	The registration code assigns minor numbers based on the type
  *	requested. -ENFILE is returned in all the device slots for this
--- head.orig/Documentation/DocBook/videobook.tmpl
+++ head/Documentation/DocBook/videobook.tmpl
@@ -1648,7 +1648,7 @@ static struct video_buffer capture_fb;
 
   <chapter id="pubfunctions">
      <title>Public Functions Provided</title>
-!Edrivers/media/video/videodev.c
+!Edrivers/media/video/v4l2-dev.c
   </chapter>
 
 </book>
