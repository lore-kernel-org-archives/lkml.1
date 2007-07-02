Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbXGBRhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbXGBRhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 13:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbXGBRhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 13:37:31 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:43025 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbXGBRha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 13:37:30 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 2 Jul 2007 13:34:55 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: linville@tuxdriver.com
Subject: [PATCH] WIRELESS: Remove clearly obsolete libertas/version.h file.
Message-ID: <Pine.LNX.4.64.0707021330300.12975@localhost.localdomain>
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


Remove a header file that was ostensibly "removed" before, in commit
3ce40232.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  this header file currently contains nothing but a linefeed and is
included by nothing else, and the fact that it was "removed" before is
shown in its log:

commit 3ce4023275a9d65d913d738846cea4a844e24b51
Author: Dan Williams <dcbw@redhat.com>
Date:   Thu May 10 23:03:07 2007 -0400

    [PATCH] libertas: Get rid of version.h

    Signed-off-by: Dan Williams <dcbw@redhat.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>


diff --git a/drivers/net/wireless/libertas/version.h b/drivers/net/wireless/libertas/version.h
deleted file mode 100644
index 8b13789..0000000
--- a/drivers/net/wireless/libertas/version.h
+++ /dev/null
@@ -1 +0,0 @@
-
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
