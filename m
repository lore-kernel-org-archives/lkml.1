Return-Path: <linux-kernel-owner+w=401wt.eu-S1946744AbXD3Tom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946744AbXD3Tom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946745AbXD3Tom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:44:42 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:38639 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946744AbXD3Tol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:44:41 -0400
X-Originating-Ip: 74.109.98.66
Date: Mon, 30 Apr 2007 15:44:27 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH] KCONFIG:  Correct minor typo in Kconfig warning message.
Message-ID: <Pine.LNX.4.64.0704301543040.4585@localhost.localdomain>
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


Correct a minor spelling mistake in a Kconfig warning message.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index c86c27f..f14aeac 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -203,7 +203,7 @@ void sym_check_prop(struct symbol *sym)
 			else if (sym2->type == S_UNKNOWN)
 				prop_warn(prop,
 				    "'select' used by config symbol '%s' "
-				    "refer to undefined symbol '%s'",
+				    "refers to undefined symbol '%s'",
 				    sym->name, sym2->name);
 			else if (sym2->type != S_BOOLEAN && sym2->type != S_TRISTATE)
 				prop_warn(prop,
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
