Return-Path: <linux-kernel-owner+w=401wt.eu-S1762888AbXJLRVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762888AbXJLRVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760431AbXJLRTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:19:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762729AbXJLRTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:19:49 -0400
Date: Fri, 12 Oct 2007 18:19:45 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [2.6.24 PATCH 15/25] dm mpath: emc fix an error message
Message-ID: <20071012171945.GA24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alasdair G Kergon <agk@redhat.com>

Correct an error message, reported by Michael Wood <michael@frogfoot.com>.

Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-emc.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23/drivers/md/dm-emc.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-emc.c	2007-10-12 13:15:40.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-emc.c	2007-10-12 13:18:14.000000000 +0100
@@ -83,7 +83,7 @@ static struct bio *get_failover_bio(stru
 	}
 
 	if (bio_add_page(bio, page, data_size, 0) != data_size) {
-		DMERR("get_failover_bio: alloc_page() failed.");
+		DMERR("get_failover_bio: bio_add_page() failed.");
 		__free_page(page);
 		bio_put(bio);
 		return NULL;
