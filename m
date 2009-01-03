Return-Path: <linux-kernel-owner+w=401wt.eu-S932442AbZACHxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbZACHxV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 02:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZACHxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 02:53:12 -0500
Received: from vps1.tull.net ([66.180.172.116]:49106 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750759AbZACHxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 02:53:12 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 03/11] Fix misspelling of "firmware" in ipw2100.c
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 03 Jan 2009 18:52:40 +1100
Message-ID: <20090103075230.27466.16505.stgit@marcab.local>
In-Reply-To: <20090103074923.27466.7287.stgit@marcab.local>
References: <20090103074923.27466.7287.stgit@marcab.local>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misspelling of "firmware" in ipw2100.c

It's spelled "firmware".

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/net/wireless/ipw2100.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index bca7481..d617c16 100644
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -1828,7 +1828,7 @@ static void ipw2100_down(struct ipw2100_priv *priv)
 		cancel_delayed_work(&priv->rf_kill);
 	}
 
-	/* Kill the firmare hang check timer */
+	/* Kill the firmware hang check timer */
 	if (!priv->stop_hang_check) {
 		priv->stop_hang_check = 1;
 		cancel_delayed_work(&priv->hang_check);

