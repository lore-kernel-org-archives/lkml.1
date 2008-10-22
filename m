Return-Path: <linux-kernel-owner+w=401wt.eu-S1760353AbYJVVlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353AbYJVVlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbYJVVlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:41:19 -0400
Received: from mail.fieldses.org ([66.93.2.214]:42877 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbYJVVlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:41:18 -0400
Date: Wed, 22 Oct 2008 17:41:16 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>, Chuck Lever <chuck.lever@oracle.com>
Subject: nfsd fixes for 2.6.28
Message-ID: <20081022214116.GA7454@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following nfsd fixes are available in the git repository at:

  git://linux-nfs.org/~bfields/linux.git for-2.6.28

The patch from Chuck is the important one, fixing a regression we just
introduced which could cause nfsd to crash on shutdown.

The rest just fixes two memory leask in error paths, with some very
minor associated cleanup.

--b.

Chuck Lever (1):
      NFSD: Fix BUG during NFSD shutdown processing

J. Bruce Fields (1):
      nfsd: clean up expkey_parse error cases

Krishna Kumar (2):
      nfsd: Fix memory leak in nfsd_getxattr
      nfsd: Drop reference in expkey_parse error cases

 fs/nfsd/export.c |   19 ++++++++++---------
 fs/nfsd/nfssvc.c |    4 ++++
 fs/nfsd/vfs.c    |    6 +++++-
 3 files changed, 19 insertions(+), 10 deletions(-)
