Return-Path: <linux-kernel-owner+w=401wt.eu-S1759918AbZKLBga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918AbZKLBga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 20:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759893AbZKLBg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 20:36:29 -0500
Received: from picton.eecg.toronto.edu ([128.100.10.141]:40405 "EHLO
	picton.eecg.toronto.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759887AbZKLBg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 20:36:28 -0500
X-Greylist: delayed 3637 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Nov 2009 20:36:28 EST
Date: Wed, 11 Nov 2009 19:35:45 -0500
From: Livio Soares <livio@eecg.toronto.edu>
To: linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext3/jdb log_start_commit export symbol issue
Message-ID: <20091112003545.GB17247@eecg.toronto.edu>
Mail-Followup-To: Livio Soares <livio@eecg.toronto.edu>,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Jan and all,

  It seems like the below patch is necessary when trying to compile ext3 as
a module. I don't  know if this is the correct fix  (that's up to you), but
without ext3 does not link. The following commit caused the problem:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=fe8bc91c4c30122b357d197117705cfd4fabaf28

  Cheers,

		Livio

Signed-off-by: Livio Soares <livio@eecg.toronto.edu>

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
