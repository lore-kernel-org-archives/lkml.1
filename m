Return-Path: <linux-kernel-owner+w=401wt.eu-S1764873AbXEUKUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764873AbXEUKUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762284AbXEUKK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:10:58 -0400
Received: from [216.16.235.2] ([216.16.235.2]:46185 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1762237AbXEUKKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:10:49 -0400
X-Originating-Ip: 72.143.65.211
Date: Mon, 21 May 2007 06:08:52 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, clameter@sgi.com
Subject: [PATCH] Remove the deprecated "kmem_cache_t" typedef from slab.h.
Message-ID: <Pine.LNX.4.64.0705210604030.17699@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Given that there is no remaining usage of the deprecated kmem_cache_t
typedef anywhere in the tree, remove that typedef.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

this removal will, of course, break out-of-tree usage but this typedef
has been deprecated since Dec of 2006 (commit
1b1cec4bbc59feac89670d5d6d222a02545bac94) and since this won't go in
until 2.6.22, is six months enough time for constant build warnings to
convince people to stop using deprecated features?  :-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index a015236..fc13cef 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -14,8 +14,6 @@
 #include <linux/gfp.h>
 #include <linux/types.h>

-typedef struct kmem_cache kmem_cache_t __deprecated;
-
 /*
  * Flags to pass to kmem_cache_create().
  * The ones marked DEBUG are only valid if CONFIG_SLAB_DEBUG is set.


 --
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
