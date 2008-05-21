Return-Path: <linux-kernel-owner+w=401wt.eu-S936209AbYEURmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936209AbYEURmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936154AbYEURlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:41:00 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:39974 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936142AbYEURk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:40:59 -0400
Date: Wed, 21 May 2008 20:38:43 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [2.6 patch] CONFIG_SOUND_WM97XX: remove stale makefile line
Message-ID: <20080521173843.GD15355@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is gone for a long time.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
5aead6331a39f4e2e2ee31f9ea1ff092843a3f99 diff --git a/sound/oss/Makefile b/sound/oss/Makefile
index 1f86299..d0440be 100644
--- a/sound/oss/Makefile
+++ b/sound/oss/Makefile
@@ -32,8 +32,6 @@ obj-$(CONFIG_SOUND_AU1550_AC97)	+= au1550_ac97.o ac97_codec.o
 obj-$(CONFIG_SOUND_TRIDENT)	+= trident.o ac97_codec.o
 obj-$(CONFIG_SOUND_BCM_CS4297A)	+= swarm_cs4297a.o
 
-obj-$(CONFIG_SOUND_WM97XX)	+= ac97_plugin_wm97xx.o
-
 obj-$(CONFIG_DMASOUND)		+= dmasound/
 
 # Declare multi-part drivers.

