Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbZCETSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbZCETSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592AbZCETRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:17:23 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:49899 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956AbZCETRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:17:21 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH v2 11/15] NULL noise: drivers/video/via/hw.c
Date: Thu, 05 Mar 2009 20:16:50 +0100
Message-ID: <20090305191646.30062.6857.stgit@f10box.hanneseder.net>
In-Reply-To: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: trivial@kernel.org
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  drivers/video/via/hw.c:2020:46: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
v2: other subject, as suggested by Al Viro

 drivers/video/via/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index fcd53ce..70d6b6c 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2017,7 +2017,7 @@ static void init_gfx_chip_info(void)
 	/* Indentify GFX Chip Name */
 	for (i = 0; pciidlist[i].vendor != 0; i++) {
 		pdev = pci_get_device(pciidlist[i].vendor,
-			pciidlist[i].device, 0);
+			pciidlist[i].device, NULL);
 		if (pdev)
 			break;
 	}

