Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbXKGHd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbXKGHd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 02:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbXKGHdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 02:33:51 -0500
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:46269 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427AbXKGHdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 02:33:50 -0500
Subject: [PATCH -libata] nv_hardreset: update dangling reference to
	bugzilla entry
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: jeff@garzik.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 07 Nov 2007 16:33:49 +0900
Message-Id: <1194420829.28494.9.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.24-rc2-orig/drivers/ata/sata_nv.c linux-2.6.24-rc2/drivers/ata/sata_nv.c
--- linux-2.6.24-rc2-orig/drivers/ata/sata_nv.c	2007-11-07 10:28:41.000000000 +0900
+++ linux-2.6.24-rc2/drivers/ata/sata_nv.c	2007-11-07 16:29:21.000000000 +0900
@@ -1629,7 +1629,7 @@ static int nv_hardreset(struct ata_link 
 
 	/* SATA hardreset fails to retrieve proper device signature on
 	 * some controllers.  Don't classify on hardreset.  For more
-	 * info, see http://bugme.osdl.org/show_bug.cgi?id=3352
+	 * info, see http://bugzilla.kernel.org/show_bug.cgi?id=3352
 	 */
 	return sata_std_hardreset(link, &dummy, deadline);
 }


