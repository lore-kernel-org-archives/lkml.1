Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbXIORuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbXIORuM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 13:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbXIORuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 13:50:00 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:36530 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbXIORuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 13:50:00 -0400
Message-ID: <46EC1B24.1010600@gmail.com>
Date: Sat, 15 Sep 2007 19:49:24 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] lib/iomap.c:bad_io_access() -- print 0x hex prefix
Content-Type: multipart/mixed;
 boundary="------------040901020606030901050706"
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040901020606030901050706
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrew.

Trivial -- be explicit about printing hex.

Rene

--------------040901020606030901050706
Content-Type: text/plain;
 name="bad_io_access-hex.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="bad_io_access-hex.diff"

diff --git a/lib/iomap.c b/lib/iomap.c
index a57d262..5dfcbde 100644
--- a/lib/iomap.c
+++ b/lib/iomap.c
@@ -40,7 +40,7 @@ static void bad_io_access(unsigned long port, const char *access)
 	static int count = 10;
 	if (count) {
 		count--;
-		printk(KERN_ERR "Bad IO access at port %lx (%s)\n", port, access);
+		printk(KERN_ERR "Bad IO access at port %#lx (%s)\n", port, access);
 		WARN_ON(1);
 	}
 }

--------------040901020606030901050706--
