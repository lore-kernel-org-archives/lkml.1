Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbZKLFev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbZKLFev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 00:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbZKLFeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 00:34:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbZKLFeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 00:34:50 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: linux-kernel@vger.kernel.org
Subject: [BUILD FAILURE][PATCH] Export symbol log_start_commit. ext3 needs it.
Date: Thu, 12 Nov 2009 11:06:52 +0530
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andreas Dilger <adilger@sun.com>, Jan Kara <jack@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911121106.52555.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The linus git fails to build with the message
ERROR: "log_start_commit" [fs/ext3/ext3.ko] undefined!
Top commit id: aa021baa3295fa6e3f367d80f8955dd5176656eb

Export log_start_commit to modules. ext3 needs it to be built
as a module.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 49d5cd6..2e13cf3 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -72,6 +72,7 @@ EXPORT_SYMBOL(journal_abort);
 EXPORT_SYMBOL(journal_errno);
 EXPORT_SYMBOL(journal_ack_err);
 EXPORT_SYMBOL(journal_clear_err);
+EXPORT_SYMBOL(log_start_commit);
 EXPORT_SYMBOL(log_wait_commit);
 EXPORT_SYMBOL(journal_start_commit);
 EXPORT_SYMBOL(journal_force_commit_nested);
