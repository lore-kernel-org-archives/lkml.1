Return-Path: <linux-kernel-owner+w=401wt.eu-S1762792AbXIZW3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762792AbXIZW3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759006AbXIZW3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:29:17 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57543 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756560AbXIZW3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:29:16 -0400
Date: Wed, 26 Sep 2007 23:35:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm  ecryptfs warning spew on 64bit
Message-ID: <20070926233520.5db0e8c0@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Its a size_t to use %Zd

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.23rc8-mm1/fs/ecryptfs/crypto.c linux-2.6.23rc8-mm1/fs/ecryptfs/crypto.c
--- linux.vanilla-2.6.23rc8-mm1/fs/ecryptfs/crypto.c	2007-09-26 16:46:54.000000000 +0100
+++ linux-2.6.23rc8-mm1/fs/ecryptfs/crypto.c	2007-09-26 17:31:47.000000000 +0100
@@ -1439,7 +1439,7 @@
 		 * crypt_stat->num_header_extents_at_front)
 		< ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE)) {
 		rc = -EINVAL;
-		printk(KERN_WARNING "Invalid number of header extents: [%d]\n",
+		printk(KERN_WARNING "Invalid number of header extents: [%Zd]\n",
 		       crypt_stat->num_header_extents_at_front);
 	}
 	return rc;
