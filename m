Return-Path: <linux-kernel-owner+w=401wt.eu-S934927AbYEBNiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934927AbYEBNiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 09:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760991AbYEBNiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 09:38:00 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58461 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759486AbYEBNiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 09:38:00 -0400
Date: Fri, 2 May 2008 14:29:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hfsplus: Correct user visible printk
Message-ID: <20080502142925.2e439d8a@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The verb form is "journalised". Confirmed with the OED and BCS

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/fs/hfsplus/super.c linux-2.6.25-mm1/fs/hfsplus/super.c
--- linux.vanilla-2.6.25-mm1/fs/hfsplus/super.c	2008-04-28 11:36:50.000000000 +0100
+++ linux-2.6.25-mm1/fs/hfsplus/super.c	2008-05-02 13:37:20.000000000 +0100
@@ -261,7 +261,7 @@
 			sb->s_flags |= MS_RDONLY;
 			*flags |= MS_RDONLY;
 		} else if (vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_JOURNALED)) {
-			printk(KERN_WARNING "hfs: filesystem is marked journaled, leaving read-only.\n");
+			printk(KERN_WARNING "hfs: filesystem is marked journalised, leaving read-only.\n");
 			sb->s_flags |= MS_RDONLY;
 			*flags |= MS_RDONLY;
 		}
