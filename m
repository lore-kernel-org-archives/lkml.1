Return-Path: <linux-kernel-owner+w=401wt.eu-S934417AbXGZRiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934417AbXGZRiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 13:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762721AbXGZRiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 13:38:46 -0400
Received: from [81.2.110.250] ([81.2.110.250]:54396 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764253AbXGZRip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 13:38:45 -0400
Date: Thu, 26 Jul 2007 18:45:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: greg@kroah.com, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nozomi: shoot defunct label
Message-ID: <20070726184535.2ddfc29f@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No longer called after the cleanup so can go in the bitbucket.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/drivers/char/nozomi.c linux-2.6.23rc1-mm1/drivers/char/nozomi.c
--- linux.vanilla-2.6.23rc1-mm1/drivers/char/nozomi.c	2007-07-26 15:02:57.000000000 +0100
+++ linux-2.6.23rc1-mm1/drivers/char/nozomi.c	2007-07-26 15:27:09.103257000 +0100
@@ -1930,7 +1930,6 @@
 			D1(" - OUTBOUND XON/XOFF is disabled");
 	}
 
-      exit_termios:
 	return;
 }
 
