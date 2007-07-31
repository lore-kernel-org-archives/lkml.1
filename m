Return-Path: <linux-kernel-owner+w=401wt.eu-S1759436AbXGaRZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436AbXGaRZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765396AbXGaRZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:25:28 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1752 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765125AbXGaRZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:25:26 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 17] drivers/md/dm-path-selector.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 19:25:26 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311925.26938.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/md/dm-path-selector.c | 2666 -> 2636 (-30 bytes)
 drivers/md/dm-path-selector.o | 101207 -> 101031 (-176 bytes)

 drivers/md/dm-path-selector.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/md/dm-path-selector.c	2007-07-26 13:07:41.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/md/dm-path-selector.c	2007-07-31 11:26:53.000000000 +0200
@@ -94,12 +94,11 @@ out:

 static struct ps_internal *_alloc_path_selector(struct path_selector_type *pst)
 {
-	struct ps_internal *psi = kmalloc(sizeof(*psi), GFP_KERNEL);
-
-	if (psi) {
-		memset(psi, 0, sizeof(*psi));
+	struct ps_internal *psi;
+
+	psi = kzalloc(sizeof(*psi), GFP_KERNEL);
+	if (psi)
 		psi->pst = *pst;
-	}

 	return psi;
 }
