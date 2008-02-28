Return-Path: <linux-kernel-owner+w=401wt.eu-S1761446AbYB1TLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761446AbYB1TLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757816AbYB1TLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:11:19 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:19675 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756991AbYB1TLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:11:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wtKG7lIFkaNat90lNHLMkeo0sIXy6rLJRBY4D4+yhQT8jnZNEihGaEppGpBOg1m2zLTX9oaoprBeYKdq+/B3wAYkG0DEvUvlP2of5fn1ojxoZyI54oE9AoJwgJ+Bltz3Z/PJcWmCaceL/OFZwKaZQ0HNt18QIfmx/znnvuS6vhs=
Subject: [PATCH 4/8] sound: ice1712: unused structs
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 11:11:13 -0800
Message-Id: <1204225873.20280.82.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't need to declare a struct when defining a structure layout.  Both
of these structs are unused.
sound/pci/ice1712/revo.c:39:3: warning: symbol 'revo51' was not declared. Should it be static?
sound/pci/ice1712/phase.c:54:3: warning: symbol 'phase28' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/ice1712/phase.c |    2 +-
 sound/pci/ice1712/revo.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/ice1712/phase.c b/sound/pci/ice1712/phase.c
index 9ab4a9f..5a158b7 100644
--- a/sound/pci/ice1712/phase.c
+++ b/sound/pci/ice1712/phase.c
@@ -51,7 +51,7 @@
 struct phase28_spec {
 	unsigned short master[2];
 	unsigned short vol[8];
-} phase28;
+};
 
 /* WM8770 registers */
 #define WM_DAC_ATTEN		0x00	/* DAC1-8 analog attenuation */
diff --git a/sound/pci/ice1712/revo.c b/sound/pci/ice1712/revo.c
index ddd5fc8..301bf92 100644
--- a/sound/pci/ice1712/revo.c
+++ b/sound/pci/ice1712/revo.c
@@ -36,7 +36,7 @@
 struct revo51_spec {
 	struct snd_i2c_device *dev;
 	struct snd_pt2258 *pt2258;
-} revo51;
+};
 
 static void revo_i2s_mclk_changed(struct snd_ice1712 *ice)
 {
-- 
1.5.4.3.342.g99e8


