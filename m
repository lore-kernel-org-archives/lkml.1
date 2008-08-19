Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbYHSJhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbYHSJhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYHSJhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:37:40 -0400
Received: from styx.suse.cz ([82.119.242.94]:59376 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752165AbYHSJhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:37:40 -0400
Date: Tue, 19 Aug 2008 11:37:38 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PATCH] UDF fixes for 2.6.27-rc3
Message-ID: <20080819093738.GG14799@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Linus,

  please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6.git for_linus

  to get the following two UDF fixes:
Jan Kara (2):
      udf: Fix lock inversion between iprune_mutex and alloc_mutex (v2)
      udf: Fix error paths in udf_new_inode()

  The diffstat is below. Thanks.

								Honza
---
 fs/udf/ialloc.c |   44 +++++++++++++++++++-------------------------
 1 files changed, 19 insertions(+), 25 deletions(-)
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
