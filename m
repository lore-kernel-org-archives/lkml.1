Return-Path: <linux-kernel-owner+w=401wt.eu-S1765204AbZGABBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765204AbZGABBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760746AbZGAAe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:59 -0400
Received: from kroah.org ([198.145.64.141]:60414 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761482AbZGAAe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:30 2009
Message-Id: <20090701002429.939348846@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ondrej Zary <linux@rainbow-software.org>, Takashi Iwai <tiwai@suse.de>
Subject: [patch 054/108] ALSA: cmi8330: fix MPU-401 PnP init copy&paste bug
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=alsa-cmi8330-fix-mpu-401-pnp-init-copy-paste-bug.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ondrej Zary <linux@rainbow-software.org>

commit c2a30d711852e4f39c8a79135b3caa701f7a8e02 upstream.

Fix copy&paste bug in PnP MPU-401 initialization.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/isa/cmi8330.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/isa/cmi8330.c
+++ b/sound/isa/cmi8330.c
@@ -338,7 +338,7 @@ static int __devinit snd_cmi8330_pnp(int
 		return -EBUSY;
 
 	acard->mpu = pnp_request_card_device(card, id->devs[2].id, NULL);
-	if (acard->play == NULL)
+	if (acard->mpu == NULL)
 		return -EBUSY;
 
 	pdev = acard->cap;


