Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbXE0TBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbXE0TBz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 15:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXE0TBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 15:01:48 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:41688 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbXE0TBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 15:01:47 -0400
X-Originating-Ip: 72.143.65.211
Date: Sun, 27 May 2007 15:00:28 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, dmitry.torokhov@gmail.com, dtor@mail.ru
Subject: [PATCH] Delete useless reference to dead MODULE_PARM macro.
Message-ID: <Pine.LNX.4.64.0705271458170.10673@localhost.localdomain>
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


Remove a clearly useless reference to the obsolete MODULE_PARM macro.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  given that that macro call is enclosed within an obsolete
"__MODULE__" check, i have to assume that snippet of code can be
safely removed.

diff --git a/drivers/input/mouse/atarimouse.c b/drivers/input/mouse/atarimouse.c
index 43ab656..f779cb6 100644
--- a/drivers/input/mouse/atarimouse.c
+++ b/drivers/input/mouse/atarimouse.c
@@ -59,9 +59,6 @@ MODULE_LICENSE("GPL");

 static int mouse_threshold[2] = {2,2};

-#ifdef __MODULE__
-MODULE_PARM(mouse_threshold, "2i");
-#endif
 #ifdef FIXED_ATARI_JOYSTICK
 extern int atari_mouse_buttons;
 #endif


-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
