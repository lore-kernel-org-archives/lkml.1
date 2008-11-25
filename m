Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbYKYBBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbYKYBBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 20:01:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbYKYAzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:55:31 -0500
Received: from smtp.movial.fi ([62.236.91.34]:57375 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159AbYKYAzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:55:15 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH 11/20] [MTD] Make init_oct5066 function static
Date: Tue, 25 Nov 2008 02:55:02 +0200
Message-Id: <1227574511-23879-12-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function init_oct5066 is needlessly defined global in
drivers/mtd/maps/octagon-5066.c. Make it static.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/mtd/maps/octagon-5066.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/octagon-5066.c b/drivers/mtd/maps/octagon-5066.c
index 43e04c1..2b2e450 100644
--- a/drivers/mtd/maps/octagon-5066.c
+++ b/drivers/mtd/maps/octagon-5066.c
@@ -184,7 +184,7 @@ void cleanup_oct5066(void)
 	release_region(PAGE_IO, 1);
 }
 
-int __init init_oct5066(void)
+static int __init init_oct5066(void)
 {
 	int i;
 	int ret = 0;
-- 
1.5.3

