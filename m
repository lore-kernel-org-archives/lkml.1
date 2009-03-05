Return-Path: <linux-kernel-owner+w=401wt.eu-S1757493AbZCETRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbZCETRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757288AbZCETQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:16:46 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:39048 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489AbZCETQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:16:44 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH v2 10/15] NULL noise: drivers/usb/host/oxu210hp-hcd.c
Date: Thu, 05 Mar 2009 20:16:30 +0100
Message-ID: <20090305191626.30062.4592.stgit@f10box.hanneseder.net>
In-Reply-To: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: trivial@kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  drivers/usb/host/oxu210hp-hcd.c:2687:42: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
v2: other subject, as suggested by Al Viro

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

