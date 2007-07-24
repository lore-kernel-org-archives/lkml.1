Return-Path: <linux-kernel-owner+w=401wt.eu-S1763563AbXGXSNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763563AbXGXSNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757675AbXGXSN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:13:28 -0400
Received: from xyzzy.farnsworth.org ([65.39.95.219]:3104 "HELO farnsworth.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755763AbXGXSN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:13:27 -0400
From: "Dale Farnsworth" <dale@farnsworth.org>
Date: Tue, 24 Jul 2007 11:13:26 -0700
To: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] mv64x60_wdt: Check return value of nonseekable_open
Message-ID: <20070724181326.GD27445@xyzzy.farnsworth.org>
References: <20070724180738.GA27445@xyzzy.farnsworth.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724180738.GA27445@xyzzy.farnsworth.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
---
 drivers/char/watchdog/mv64x60_wdt.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c
===================================================================
--- linux-2.6-powerpc-wdt.orig/drivers/char/watchdog/mv64x60_wdt.c	2007-07-19 21:39:15.000000000 +0000
+++ linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c	2007-07-19 21:40:13.000000000 +0000
@@ -90,9 +90,7 @@ static int mv64x60_wdt_open(struct inode
 	mv64x60_wdt_service();
 	mv64x60_wdt_handler_enable();
 
-	nonseekable_open(inode, file);
-
-	return 0;
+	return nonseekable_open(inode, file);
 }
 
 static int mv64x60_wdt_release(struct inode *inode, struct file *file)

