Return-Path: <linux-kernel-owner+w=401wt.eu-S1423596AbXEAUsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423596AbXEAUsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423664AbXEAUmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:42:04 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:40177 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423633AbXEAUe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:34:57 -0400
Message-Id: <20070501203333.698826280@mail.of.borg>
References: <20070501203234.252205858@mail.of.borg>
User-Agent: quilt/0.45-1
Date: Tue, 01 May 2007 22:32:49 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Finn Thain <fthain@telegraphics.com.au>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 15/33] m68k: pmu_queue_request() declaration conflict
Content-Disposition: inline; filename=pmu_queue_request-conflict.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

Fixes a "static qualifier follows non-static qualifier" error from gcc 4.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/macintosh/via-pmu68k.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-m68k-2.6.21.orig/drivers/macintosh/via-pmu68k.c
+++ linux-m68k-2.6.21/drivers/macintosh/via-pmu68k.c
@@ -111,7 +111,6 @@ static int pmu_send_request(struct adb_r
 static int pmu_autopoll(int devs);
 void pmu_poll(void);
 static int pmu_reset_bus(void);
-static int pmu_queue_request(struct adb_request *req);
 
 static void pmu_start(void);
 static void send_byte(int x);
@@ -475,7 +474,7 @@ pmu_request(struct adb_request *req, voi
 	return pmu_queue_request(req);
 }
 
-static int 
+int
 pmu_queue_request(struct adb_request *req)
 {
 	unsigned long flags;

--
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

