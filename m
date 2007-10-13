Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbXJMMf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbXJMMf4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 08:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbXJMMf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 08:35:26 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:60748 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbXJMMfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 08:35:25 -0400
Message-Id: <20071013123413.662203144@mail.of.borg>
References: <20071013123123.085686856@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 14:31:28 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
Subject: [patch 5/8] dm: emc_endio returns void
Content-Disposition: inline; filename=dm-emc_endio-returns-void.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

emc_endio returns void:
linux/drivers/md/dm-emc.c: In function 'emc_endio':
linux/drivers/md/dm-emc.c:58: warning: 'return' with a value, in function returning void

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/md/dm-emc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/md/dm-emc.c
+++ b/drivers/md/dm-emc.c
@@ -54,8 +54,6 @@ static void emc_endio(struct bio *bio, i
 
 	/* request is freed in block layer */
 	free_bio(bio);
-
-	return 0;
 }
 
 static struct bio *get_failover_bio(struct dm_path *path, unsigned data_size)

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

