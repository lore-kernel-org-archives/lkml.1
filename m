Return-Path: <linux-kernel-owner+w=401wt.eu-S1765822AbXHOJyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765822AbXHOJyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760430AbXHOJuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:50:15 -0400
Received: from europa.telenet-ops.be ([195.130.137.75]:60874 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083AbXHOJt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:49:58 -0400
Message-Id: <20070815094851.305685679@mail.of.borg>
References: <20070815094539.181979221@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Wed, 15 Aug 2007 11:45:49 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 10/10] zorro: Make sysfs `config attribute read-only
Content-Disposition: inline; filename=zorro_config_attr-read-only.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

zorro: Make the sysfs `config' attribute read-only, as you cannot write to it
(there's no .write function neither).

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/zorro/zorro-sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/zorro/zorro-sysfs.c
+++ b/drivers/zorro/zorro-sysfs.c
@@ -78,7 +78,7 @@ static ssize_t zorro_read_config(struct 
 static struct bin_attribute zorro_config_attr = {
 	.attr =	{
 		.name = "config",
-		.mode = S_IRUGO | S_IWUSR,
+		.mode = S_IRUGO,
 	},
 	.size = sizeof(struct ConfigDev),
 	.read = zorro_read_config,

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

