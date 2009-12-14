Return-Path: <linux-kernel-owner+w=401wt.eu-S932504AbZLNUp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbZLNUp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 15:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbZLNUp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 15:45:56 -0500
Received: from cantor.suse.de ([195.135.220.2]:57845 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbZLNUp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 15:45:56 -0500
Date: Mon, 14 Dec 2009 21:45:50 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PULL] UDF changes for 2.6.33-rc1
Message-ID: <20091214204549.GM4731@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  sorry for a bit late request (I forgot to send it last week).
Could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6.git for_linus

  to get:

Jan Kara (3):
      udf: Fix compilation with UDFFS_DEBUG enabled
      udf: Try harder when looking for VAT inode
      udf: Avoid IO in udf_clear_inode

The diffstat is

 fs/udf/balloc.c |    2 +-
 fs/udf/file.c   |    1 +
 fs/udf/inode.c  |   24 ++++++++++++------------
 fs/udf/namei.c  |   38 ++++++++++++++++++++++++++++----------
 fs/udf/super.c  |   32 ++++++++++++++++++++++++--------
 5 files changed, 66 insertions(+), 31 deletions(-)

							Thanks
								Honza
  
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
