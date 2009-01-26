Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZAZCIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZAZCIe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 21:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbZAZCH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 21:07:56 -0500
Received: from vps1.tull.net ([66.180.172.116]:36468 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754464AbZAZCHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 21:07:55 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 16/20] Fix misspelling of firmware in aica.c
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 13:07:48 +1100
Message-ID: <20090126020748.15168.58237.stgit@marcab.local.tull.net>
In-Reply-To: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
References: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misspelling of firmware in aica.c

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 sound/sh/aica.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/sound/sh/aica.c b/sound/sh/aica.c
index 7c920f3..b1a5229 100644
--- a/sound/sh/aica.c
+++ b/sound/sh/aica.c
@@ -565,7 +565,7 @@ static int load_aica_firmware(void)
 	err = request_firmware(&fw_entry, "aica_firmware.bin", &pd->dev);
 	if (unlikely(err))
 		return err;
-	/* write firware into memory */
+	/* write firmware into memory */
 	spu_disable();
 	spu_memload(0, fw_entry->data, fw_entry->size);
 	spu_enable();

