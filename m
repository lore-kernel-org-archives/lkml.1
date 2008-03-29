Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbYC2UzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbYC2UzR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 16:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbYC2UzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 16:55:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33344 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbYC2UzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 16:55:05 -0400
Date: Sat, 29 Mar 2008 21:55:36 +0100
From: Pavel Machek <pavel@suse.cz>
To: perex@perex.cz, kernel list <linux-kernel@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>, tiwai@suse.de
Subject: fix comments in sound/core.h
Message-ID: <20080329205536.GA10942@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two sentences seem to be spliced into one in comment, fix that and fix
english. Also fix codingstyle.

Signed-off-by: Pavel Machek <pavel@suse.cz> 

diff --git a/include/sound/core.h b/include/sound/core.h
index 4fc0235..452000d 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -310,7 +310,7 @@ int snd_card_file_add(struct snd_card *c
 int snd_card_file_remove(struct snd_card *card, struct file *file);
 
 #ifndef snd_card_set_dev
-#define snd_card_set_dev(card,devptr) ((card)->dev = (devptr))
+#define snd_card_set_dev(card, devptr) ((card)->dev = (devptr))
 #endif
 
 /* device.c */
@@ -373,7 +373,7 @@ #ifdef CONFIG_SND_VERBOSE_PRINTK
  * snd_printd - debug printk
  * @fmt: format string
  *
- * Compiled only when Works like snd_printk() for debugging purpose.
+ * Works like snd_printk() for debugging purposes.
  * Ignored when CONFIG_SND_DEBUG is not set.
  */
 #define snd_printd(fmt, args...) \
@@ -417,7 +417,7 @@ #ifdef CONFIG_SND_DEBUG_DETECT
  * snd_printdd - debug printk
  * @format: format string
  *
- * Compiled only when Works like snd_printk() for debugging purpose.
+ * Works like snd_printk() for debugging purposes.
  * Ignored when CONFIG_SND_DEBUG_DETECT is not set.
  */
 #define snd_printdd(format, args...) snd_printk(format, ##args)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

