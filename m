Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbYA0Miy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbYA0Miy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 07:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757012AbYA0MfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 07:35:21 -0500
Received: from ananke.telenet-ops.be ([195.130.137.78]:54810 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbYA0MfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 07:35:00 -0500
Message-Id: <20080127123359.285567263@mail.of.borg>
References: <20080127123216.897698766@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 27 Jan 2008 13:32:27 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Finn Thain <fthain@telegraphics.com.au>
Subject: [patch 11/14] mac68k: macii adb comment correction
Content-Disposition: inline; filename=mac68k-macii-adb-comment-correction.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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

