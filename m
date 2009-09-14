Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbZINRwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbZINRwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 13:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbZINRw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 13:52:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57526 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbZINRw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 13:52:26 -0400
Date: Mon, 14 Sep 2009 19:52:28 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PULL REQUEST] UDF fixes for 2.6.32-rc1
Message-ID: <20090914175228.GF25549@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6.git for_linus

  to get:

Jan Kara (4):
      udf: Remove dead code
      udf: Remove wrong assignment in udf_symlink
      udf: Perform preallocation only for regular files
      udf: Fix possible corruption when close races with write

The diffstat is

 fs/udf/directory.c |   86 ----------------------------------------------------
 fs/udf/file.c      |    2 +
 fs/udf/inode.c     |   19 ++++++-----
 fs/udf/lowlevel.c  |    4 --
 fs/udf/namei.c     |    1 -
 5 files changed, 12 insertions(+), 100 deletions(-)

                                                        Thanks
                                                                Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
