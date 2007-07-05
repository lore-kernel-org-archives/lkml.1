Return-Path: <linux-kernel-owner+w=401wt.eu-S1761770AbXGETJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761770AbXGETJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 15:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759628AbXGETJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 15:09:19 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:50306 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759457AbXGETJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 15:09:18 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 5 Jul 2007 15:06:29 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, perex@suse.cz
Subject: [PATCH] SOUND:  Remove unreferenced header file include/sound/wavefront_fx.h.
Message-ID: <Pine.LNX.4.64.0707051504330.18942@localhost.localdomain>
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

  not sure who the proper SOUND subsystem maintainer would be here, so
i just took a chance.

diff --git a/include/sound/wavefront_fx.h b/include/sound/wavefront_fx.h
deleted file mode 100644
index cec92b1..0000000
--- a/include/sound/wavefront_fx.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef __SOUND_WAVEFRONT_FX_H
-#define __SOUND_WAVEFRONT_FX_H
-
-extern int  snd_wavefront_fx_detect (snd_wavefront_t *);
-extern void snd_wavefront_fx_ioctl  (snd_synth_t *sdev,
-				     unsigned int cmd,
-				     unsigned long arg);
-
-#endif  __SOUND_WAVEFRONT_FX_H
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
