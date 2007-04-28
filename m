Return-Path: <linux-kernel-owner+w=401wt.eu-S1161175AbXD1TUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161175AbXD1TUj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161071AbXD1TUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:20:06 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37513 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030490AbXD1TT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:19:56 -0400
Date: Sat, 28 Apr 2007 21:20:08 +0200
From: Adrian Bunk <bunk@stusta.de>
To: mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] cx88-mpeg.c: make 2 functions static
Message-ID: <20070428192008.GU3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes two needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/media/video/cx88/cx88-mpeg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.21-rc7-mm2/drivers/media/video/cx88/cx88-mpeg.c.old	2007-04-28 15:09:50.000000000 +0200
+++ linux-2.6.21-rc7-mm2/drivers/media/video/cx88/cx88-mpeg.c	2007-04-28 15:10:06.000000000 +0200
@@ -611,7 +611,7 @@
 }
 
 /* Driver asked for hardware access. */
-int cx8802_request_acquire(struct cx8802_driver *drv)
+static int cx8802_request_acquire(struct cx8802_driver *drv)
 {
 	struct cx88_core *core = drv->core;
 
@@ -631,7 +631,7 @@
 }
 
 /* Driver asked to release hardware. */
-int cx8802_request_release(struct cx8802_driver *drv)
+static int cx8802_request_release(struct cx8802_driver *drv)
 {
 	struct cx88_core *core = drv->core;
 

