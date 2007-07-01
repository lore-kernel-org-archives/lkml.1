Return-Path: <linux-kernel-owner+w=401wt.eu-S1757982AbXGAQvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbXGAQvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 12:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbXGAQvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 12:51:44 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:45918 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbXGAQvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 12:51:43 -0400
X-Originating-Ip: 72.143.66.27
Date: Sun, 1 Jul 2007 12:49:58 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] SPARC64: Emphasize that sparc64 doesn't support return
 probes.
Message-ID: <Pine.LNX.4.64.0707011248490.3046@localhost.localdomain>
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


Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index 89a1b46..6b04c86 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -446,6 +446,7 @@ config KPROBES
 	  execute a callback function.  register_kprobe() establishes
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
+	  (Note that sparc64 does *not* currently support return probes.)
 	  If in doubt, say "N".
 endmenu

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
