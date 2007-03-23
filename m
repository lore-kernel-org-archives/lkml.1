Return-Path: <linux-kernel-owner+w=401wt.eu-S933875AbXCWRwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875AbXCWRwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 13:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933879AbXCWRwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 13:52:19 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35164 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933875AbXCWRwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 13:52:18 -0400
Date: Fri, 23 Mar 2007 18:55:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tty: minor merge correction
Message-ID: <20070323185547.3d601b09@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Its now used.. because we added the new definitions so enabled all the
goodies on i386

Signed-off-by: Alan Cox <alan@redhat.com>

[and a signed off for the ide merge oddments I just posted without]

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc4-mm1/include/asm-i386/termbits.h linux-2.6.21-rc4-mm1/include/asm-i386/termbits.h
--- linux.vanilla-2.6.21-rc4-mm1/include/asm-i386/termbits.h	2007-03-23 11:49:51.000000000 +0000
+++ linux-2.6.21-rc4-mm1/include/asm-i386/termbits.h	2007-03-23 13:25:35.000000000 +0000
@@ -156,7 +156,7 @@
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
-#define CIBAUD	  002003600000	/* input baud rate (not used) */
+#define CIBAUD	  002003600000
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
 
