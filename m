Return-Path: <linux-kernel-owner+w=401wt.eu-S932507AbXHHN2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507AbXHHN2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 09:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757432AbXHHN2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 09:28:15 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47055 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755373AbXHHN2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 09:28:14 -0400
Date: Wed, 8 Aug 2007 14:35:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] mxser: Remove use of dead TTY_FLIPBUF_SIZE definition
Message-ID: <20070808143546.5f93071e@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We simply define it to the same value. Nowdays the TTY flip value is
irrelevant but the value it used is as good as any so why risk breaking it

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/drivers/char/mxser.h linux-2.6.23rc1-mm1/drivers/char/mxser.h
--- linux.vanilla-2.6.23rc1-mm1/drivers/char/mxser.h	2007-07-26 15:01:31.000000000 +0100
+++ linux-2.6.23rc1-mm1/drivers/char/mxser.h	2007-08-08 11:45:44.323496144 +0100
@@ -30,8 +30,7 @@
 
 #define TTY_THRESHOLD_THROTTLE  128
 
-#define LO_WATER	 	(TTY_FLIPBUF_SIZE)
-#define HI_WATER		(TTY_FLIPBUF_SIZE*2*3/4)
+#define HI_WATER		768
 
 // added by James. 03-11-2004.
 #define MOXA_SDS_GETICOUNTER  	(MOXA + 68)
