Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbXFLXEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbXFLXEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 19:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbXFLXDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 19:03:15 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33084 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754174AbXFLXDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 19:03:09 -0400
Date: Wed, 13 Jun 2007 01:03:21 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Engelhardt <jengelh@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make drivers/char/selection.c:store_utf8() static
Message-ID: <20070612230321.GD3588@stusta.de>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global store_utf8() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc4-mm2/drivers/char/selection.c.old	2007-06-13 00:23:09.000000000 +0200
+++ linux-2.6.22-rc4-mm2/drivers/char/selection.c	2007-06-13 00:23:20.000000000 +0200
@@ -112,7 +112,7 @@
 }
 
 /* stores the char in UTF8 and returns the number of bytes used (1-3) */
-int store_utf8(u16 c, char *p)
+static int store_utf8(u16 c, char *p)
 {
 	if (c < 0x80) {
 		/*  0******* */

