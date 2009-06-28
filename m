Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbZF1Qkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbZF1Qkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757433AbZF1Q2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:28:33 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1178 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbZF1Q2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:28:16 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       xen-devel@lists.xensource.com, virtualization@lists.osdl.org
Subject: [PATCH 53/62] drivers/xen/balloon.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:58 -0700
Message-Id: <36cb48396faf4b0382e1bee6911059e9861a3509.1246173683.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/xen/balloon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index f5bbd9e..4d1b322 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -214,7 +214,7 @@ static int increase_reservation(unsigned long nr_pages)
 	page = balloon_first_page();
 	for (i = 0; i < nr_pages; i++) {
 		BUG_ON(page == NULL);
-		frame_list[i] = page_to_pfn(page);;
+		frame_list[i] = page_to_pfn(page);
 		page = balloon_next_page(page);
 	}
 
-- 
1.6.3.1.10.g659a0.dirty

