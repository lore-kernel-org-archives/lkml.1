Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbYBJXZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbYBJXZD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 18:25:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756319AbYBJXYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 18:24:53 -0500
Received: from mail.fieldses.org ([66.93.2.214]:52284 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbYBJXYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 18:24:52 -0500
Date: Sun, 10 Feb 2008 18:24:48 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       Neil Brown <neilb@suse.de>
Subject: nfsd fixes for 2.6.25
Message-ID: <20080210232448.GB20829@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes are available from the for-linus branch of the git
repository at:

  git://linux-nfs.org/~bfields/linux.git for-linus

The four patches from Jeff Layton fix a bug that can allow an
unresponsive client to hang lockd.  The other two patches are minor
compile fixes.

--b.

J. Bruce Fields (1):
      nfsd: clean up svc_reserve_auth()

Jeff Layton (4):
      NLM: set RPC_CLNT_CREATE_NOPING for NLM RPC clients
      NLM: have server-side RPC clients default to soft RPC tasks
      NLM: don't reattempt GRANT_MSG when there is already an RPC in flight
      NLM: don't requeue block if it was invalidated while GRANT_MSG was in flight

Roland Dreier (1):
      SUNPRC: Fix printk format warning

 fs/lockd/host.c                       |   10 +++++++++-
 fs/lockd/svclock.c                    |   28 ++++++++++++++++++++++++----
 include/linux/sunrpc/svc.h            |   13 +++++--------
 net/sunrpc/xprtrdma/svc_rdma_sendto.c |    3 ++-
 4 files changed, 40 insertions(+), 14 deletions(-)
