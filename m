Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbZAXUuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbZAXUuf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 15:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbZAXUu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 15:50:26 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:60186 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428AbZAXUuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 15:50:25 -0500
X-Greylist: delayed 654 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Jan 2009 15:50:24 EST
Message-ID: <497B7C7F.80104@msgid.tls.msk.ru>
Date: Sat, 24 Jan 2009 23:39:27 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-serial@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: [trivial patch] fix missing space in printk drivers/serial/8250.c
Content-Type: multipart/mixed;
 boundary="------------030304000202010000080403"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030304000202010000080403
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit

Again, I don't know where to push this trivia thing.
8250 marked as Orphan in MAINTAINERS, so I'm sending
to linux-serial@ AND to linux-kernel@

Because.. when I see such mess in dmesg, it annoys me ;)

 Serial: 8250/16550 driver10 ports, IRQ sharing enabled

Signed-Off-By: Michael Tokarev <mjt@tls.msk.ru>

Thanks!

/mjt

--------------030304000202010000080403
Content-Type: text/x-patch;
 name="8250-space.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="8250-space.diff"

--- linux-2.6.28/drivers/serial/8250.c.orig	2008-12-25 02:26:37.000000000 +0300
+++ linux-2.6.28/drivers/serial/8250.c	2009-01-24 23:34:32.891807709 +0300
@@ -3020,3 +3020,3 @@ static int __init serial8250_init(void)
 
-	printk(KERN_INFO "Serial: 8250/16550 driver"
+	printk(KERN_INFO "Serial: 8250/16550 driver "
 		"%d ports, IRQ sharing %sabled\n", nr_uarts,

--------------030304000202010000080403--
