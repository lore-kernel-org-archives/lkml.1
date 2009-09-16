Return-Path: <linux-kernel-owner+w=401wt.eu-S1760347AbZIPWqC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760347AbZIPWqC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:46:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760575AbZIPWpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:45:25 -0400
Received: from kroah.org ([198.145.64.141]:48973 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760322AbZIPWj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:39:59 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:16 2009
Message-Id: <20090916223716.463198391@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sophie Hamilton <kernel@theblob.org>, Takashi Iwai <tiwai@suse.de>
Subject: [patch 22/45] ALSA: cs46xx - Fix minimum period size
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=alsa-cs46xx-fix-minimum-period-size.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sophie Hamilton <kernel@theblob.org>

commit 6148b130eb84edc76e4fa88da1877b27be6c2f06 upstream.

Fix minimum period size for cs46xx cards. This fixes a problem in the
case where neither a period size nor a buffer size is passed to ALSA;
this is the case in Audacious, OpenAL, and others.

Signed-off-by: Sophie Hamilton <kernel@theblob.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/cs46xx/cs46xx_lib.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/cs46xx/cs46xx_lib.h
+++ b/sound/pci/cs46xx/cs46xx_lib.h
@@ -35,7 +35,7 @@
 
 
 #ifdef CONFIG_SND_CS46XX_NEW_DSP
-#define CS46XX_MIN_PERIOD_SIZE 1
+#define CS46XX_MIN_PERIOD_SIZE 64
 #define CS46XX_MAX_PERIOD_SIZE 1024*1024
 #else
 #define CS46XX_MIN_PERIOD_SIZE 2048


