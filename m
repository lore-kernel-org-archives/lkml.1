Return-Path: <linux-kernel-owner+w=401wt.eu-S933502AbXFEVVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502AbXFEVVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933011AbXFEVVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:21:00 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:60307 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932860AbXFEVU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:20:59 -0400
Message-id: <1058130869771517818@wsc.cz>
Subject: [PATCH 1/3] Char: stallion, don't fail with less than max panels
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Ingo Korb" <ingo@akana.de>
Date: Tue,  5 Jun 2007 23:20:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

stallion, don't fail with less than max panels

Thanks to Ingo.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: "Ingo Korb" <ingo@akana.de>

---
commit aa7cfc04f92ec2b20a07b29a89527d836a93d00f
tree 064efb1346d6efffcd59cce827e15116c836da5b
parent db6329f0ce9fe4e7773edcabfb97f63e4f4a948f
author Jiri Slaby <jirislaby@gmail.com> Mon, 04 Jun 2007 00:05:16 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 05 Jun 2007 23:14:27 +0200

 drivers/char/stallion.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index e45113a..265abad 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -2172,7 +2172,7 @@ static int __devinit stl_initech(struct stlbrd *brdp)
 		}
 		status = inb(ioaddr + ECH_PNLSTATUS);
 		if ((status & ECH_PNLIDMASK) != nxtid)
-			goto err_fr;
+			break;
 		panelp = kzalloc(sizeof(struct stlpanel), GFP_KERNEL);
 		if (!panelp) {
 			printk("STALLION: failed to allocate memory "
