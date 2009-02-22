Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbZBVAEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbZBVAEs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 19:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbZBVAEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 19:04:39 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:41139 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbZBVAEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 19:04:38 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 09/16] usb host: fix sparse warning: Using plain integer as
	NULL pointer
To: trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 22 Feb 2009 01:04:33 +0100
Message-ID: <20090222000257.17557.27546.stgit@vmbox.hanneseder.net>
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
  drivers/usb/host/oxu210hp-hcd.c:2687:42: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/usb/host/oxu210hp-hcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index 2947c69..5ac489e 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -2684,7 +2684,7 @@ static int oxu_reset(struct usb_hcd *hcd)
 	oxu->urb_len = 0;
 
 	/* FIMXE */
-	hcd->self.controller->dma_mask = 0UL;
+	hcd->self.controller->dma_mask = NULL;
 
 	if (oxu->is_otg) {
 		oxu->caps = hcd->regs + OXU_OTG_CAP_OFFSET;

