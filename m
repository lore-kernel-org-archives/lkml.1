Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790Ab0AYUiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab0AYUiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 15:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289Ab0AYUiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 15:38:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57616 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab0AYUiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 15:38:16 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, trivial@kernel.org,
       Nicolas Pitre <nico@marvell.com>
Subject: [PATCH] trivial grammar fix: if and only if
Date: Mon, 25 Jan 2010 21:38:09 +0100
Message-Id: <1264451889-10234-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Nicolas Pitre <nico@marvell.com>
---
 mm/highmem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index 9c1e627..bed8a8b 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -220,7 +220,7 @@ EXPORT_SYMBOL(kmap_high);
  * @page: &struct page to pin
  *
  * Returns the page's current virtual memory address, or NULL if no mapping
- * exists.  When and only when a non null address is returned then a
+ * exists.  If and only if a non null address is returned then a
  * matching call to kunmap_high() is necessary.
  *
  * This can be called from any context.
-- 
1.6.6

