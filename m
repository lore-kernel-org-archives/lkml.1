Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbXKRKRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbXKRKRp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 05:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbXKRKPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 05:15:32 -0500
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:37830 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbXKRKPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 05:15:18 -0500
Message-Id: <20071118101448.815576186@mail.of.borg>
References: <20071118101336.330321764@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 Nov 2007 11:13:46 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Finn Thain <fthain@telegraphics.com.au>
Subject: [patch 10/13] mac68k: macii adb comment correction
Content-Disposition: inline; filename=mac68k-macii-adb-comment-correction.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

Corrects a mistake I made in a comment.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/macintosh/via-macii.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/macintosh/via-macii.c
+++ b/drivers/macintosh/via-macii.c
@@ -111,7 +111,7 @@ static enum macii_state {
 static struct adb_request *current_req; /* first request struct in the queue */
 static struct adb_request *last_req;     /* last request struct in the queue */
 static unsigned char reply_buf[16];        /* storage for autopolled replies */
-static unsigned char *reply_ptr;      /* next byte in req->data or reply_buf */
+static unsigned char *reply_ptr;     /* next byte in reply_buf or req->reply */
 static int reading_reply;        /* store reply in reply_buf else req->reply */
 static int data_index;      /* index of the next byte to send from req->data */
 static int reply_len; /* number of bytes received in reply_buf or req->reply */

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

