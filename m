Return-Path: <linux-kernel-owner+w=401wt.eu-S1757148AbZBVAMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbZBVAMs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 19:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756832AbZBVAMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 19:12:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:33054 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824AbZBVAMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 19:12:30 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 10/16] viafb: fix sparse warning: Using plain integer as NULL
	pointer
To: trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 22 Feb 2009 01:04:51 +0100
Message-ID: <20090222000441.17557.22989.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  drivers/video/via/hw.c:2020:46: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
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

