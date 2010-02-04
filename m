Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab0BDIYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:24:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57520 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab0BDIYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:24:43 -0500
Subject: [PATCH] Staging: comedi: fix brace coding style in comedi_fops.c
From: Paul Elms <paul@uprocera.co.uk>
To: gregkh@suse.de, wfp5p@virginia.edu, shawn.bohrer@gmail.com,
       fmhess@users.sourceforge.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 08:24:28 +0000
Message-ID: <1265271868.2483.2.camel@arthur>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18QZ5oAJvhzybUtkzhS6erDOQhKw6AB9+laULU
 kIruTUAWg4gx50MXhMzQbGuIdRWHwtXYk9VsJLq9XhYlA+G2n0
 PS5K2ILw3stvJZX6lle+quaQRjWjoAT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 38f32cfc823e40b4b64a2977bc79c00990b29837 Mon Sep 17 00:00:00 2001
From: Paul Elms <paul@uprocera.co.uk>
Date: Tue, 2 Feb 2010 17:34:50 +0000
Subject: [PATCH] Staging: comedi: fix brace coding style in comedi_fops.c

This patch to the comedi_fops.c file fixes a brace warning found by the checkpatch.pl tool
Signed-off-by: Paul Elms <paul@uprocera.co.uk>
---
 drivers/staging/comedi/comedi_fops.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 8117748..79653e8 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -2004,12 +2004,10 @@ void comedi_event(struct comedi_device *dev, struct comedi_subdevice *s)
 	if (async->cb_mask & s->async->events) {
 		if (comedi_get_subdevice_runflags(s) & SRF_USER) {
 			wake_up_interruptible(&async->wait_head);
-			if (s->subdev_flags & SDF_CMD_READ) {
+			if (s->subdev_flags & SDF_CMD_READ)
 				kill_fasync(&dev->async_queue, SIGIO, POLL_IN);
-			}
-			if (s->subdev_flags & SDF_CMD_WRITE) {
+			if (s->subdev_flags & SDF_CMD_WRITE)
 				kill_fasync(&dev->async_queue, SIGIO, POLL_OUT);
-			}
 		} else {
 			if (async->cb_func)
 				async->cb_func(s->async->events, async->cb_arg);
-- 
1.6.3.3



