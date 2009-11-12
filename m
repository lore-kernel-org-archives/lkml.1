Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbZKLJiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbZKLJiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 04:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZKLJiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 04:38:21 -0500
Received: from sirius.lasnet.de ([78.47.116.19]:41465 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbZKLJiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 04:38:20 -0500
X-Greylist: delayed 2377 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Nov 2009 04:38:20 EST
Date: Thu, 12 Nov 2009 09:58:43 +0100
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
Message-ID: <20091112085843.GA2682@excalibur.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.20 (2009-06-14)
Subject: [PATCH] fs/jbd: Export log_start_commit to fix ext3 build
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9bf22057947bfaeef14287dd03ac8f058e4dd43a Mon Sep 17 00:00:00 2001
From: Stefan Schmidt <stefan@datenfreihafen.org>
Date: Thu, 12 Nov 2009 09:53:50 +0100
Subject: [PATCH] fs/jbd: Export log_start_commit to fix ext3 build.

This fixes:
ERROR: "log_start_commit" [fs/ext3/ext3.ko] undefined!

Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
---
 fs/jbd/journal.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 49d5cd6..4160afa 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -73,6 +73,7 @@ EXPORT_SYMBOL(journal_errno);
 EXPORT_SYMBOL(journal_ack_err);
 EXPORT_SYMBOL(journal_clear_err);
 EXPORT_SYMBOL(log_wait_commit);
+EXPORT_SYMBOL(log_start_commit);
 EXPORT_SYMBOL(journal_start_commit);
 EXPORT_SYMBOL(journal_force_commit_nested);
 EXPORT_SYMBOL(journal_wipe);
-- 
1.6.5.2

