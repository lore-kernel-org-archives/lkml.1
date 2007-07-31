Return-Path: <linux-kernel-owner+w=401wt.eu-S1761402AbXGaNKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761402AbXGaNKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759915AbXGaNJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:09:10 -0400
Received: from host86-137-100-191.range86-137.btcentralplus.com ([86.137.100.191]:42959
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759526AbXGaNJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:09:09 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 09:09:04 EDT
From: jack@hawkeye.stone.uk.eu.org
Message-Id: <20070731125440.305176000@hawkeye.stone.uk.eu.org>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
User-Agent: quilt/0.46-1
Date: Tue, 31 Jul 2007 13:53:21 +0100
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [Patch 05/16] Remove unnecessary kmalloc casts in the drivers subdirectory.
Content-Disposition: inline; filename=drivers_char_remove_kmalloc_casts.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>

CC: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tty_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/char/tty_io.c
===================================================================
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2034,7 +2034,7 @@ static int init_dev(struct tty_driver *d
 	}
 
 	if (!*tp_loc) {
-		tp = (struct ktermios *) kmalloc(sizeof(struct ktermios),
+		tp = kmalloc(sizeof(struct ktermios),
 						GFP_KERNEL);
 		if (!tp)
 			goto free_mem_out;

-- 
