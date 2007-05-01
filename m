Return-Path: <linux-kernel-owner+w=401wt.eu-S1161745AbXEASwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161745AbXEASwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161746AbXEASwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:52:34 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:46417 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161745AbXEASwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:52:33 -0400
X-Originating-Ip: 74.109.98.66
Date: Tue, 1 May 2007 14:52:14 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] NET: Delete unused header file net/ipv4/tcp_yeah.h.
Message-ID: <Pine.LNX.4.64.0705011450020.23352@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Delete the apparently unused header file net/ipv4/tcp_yeah.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

kind of odd that this header file is unreferenced since there's a
matching source file net/ipv4/tcp_yeah.c.  oh, well ...

diff --git a/net/ipv4/tcp_yeah.h b/net/ipv4/tcp_yeah.h
deleted file mode 100644
index ed3b719..0000000
--- a/net/ipv4/tcp_yeah.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/inet_diag.h>
-#include <asm/div64.h>
-
-#include <net/tcp.h>
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
