Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbYLEKZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbYLEKZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 05:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757160AbYLEKVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 05:21:17 -0500
Received: from vps1.tull.net ([66.180.172.116]:47141 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756177AbYLEKVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 05:21:04 -0500
Mail-From: nobody Fri Dec  5 14:08:07 2008
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH] Fix incorrect use of loose in migrate.c
To: Christoph Lameter <cl@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: <linux-kernel@vger.kernel.org>, Nick Andrew <nick@nick-andrew.net>
Date: Fri, 05 Dec 2008 14:08:07 +1100
Message-ID: <20081205030807.32309.69191.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect use of loose in migrate.c

It should be 'lose', not 'loose'.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 mm/migrate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/mm/migrate.c b/mm/migrate.c
index 1e0d6b2..7605b2b 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -514,7 +514,7 @@ static int writeout(struct address_space *mapping, struct page *page)
 	/*
 	 * A dirty page may imply that the underlying filesystem has
 	 * the page on some queue. So the page must be clean for
-	 * migration. Writeout may mean we loose the lock and the
+	 * migration. Writeout may mean we lose the lock and the
 	 * page state is no longer what we checked for earlier.
 	 * At this point we know that the migration attempt cannot
 	 * be successful.


