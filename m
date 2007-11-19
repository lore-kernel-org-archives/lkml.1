Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbXKSWIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbXKSWIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbXKSWGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:06:34 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:62079 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756592AbXKSWGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:06:33 -0500
Date: Mon, 19 Nov 2007 22:06:32 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] MFD: SM501 debug typo fix
Message-ID: <20071119220632.GA6547@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove errnoeous x character from dev_dbg() call that
stops the driver compiling under debug.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.22-quilt2/drivers/mfd/sm501.c
===================================================================
--- linux-2.6.22-quilt2.orig/drivers/mfd/sm501.c	2007-07-09 00:32:17.000000000 +0100
+++ linux-2.6.22-quilt2/drivers/mfd/sm501.c	2007-07-28 10:38:39.000000000 +0100
@@ -156,7 +156,7 @@ static void sm501_dump_clk(struct sm501_
 
 	dev_dbg(sm->dev, "PM0[%c]: "
 		 "P2 %ld.%ld MHz (%ld), V2 %ld.%ld (%ld), "
-x		 "M %ld.%ld (%ld), MX1 %ld.%ld (%ld)\n",
+		 "M %ld.%ld (%ld), MX1 %ld.%ld (%ld)\n",
 		 (pmc & 3 ) == 0 ? '*' : '-',
 		 fmt_freq(decode_div(pll2, pm0, 24, 1<<29, 31, px_div)),
 		 fmt_freq(decode_div(pll2, pm0, 16, 1<<20, 15, misc_div)),
