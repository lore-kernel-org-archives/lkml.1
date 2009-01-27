Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbZA0XVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbZA0XVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZA0XVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:21:00 -0500
Received: from mail.fieldses.org ([141.211.133.115]:43056 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZA0XVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:21:00 -0500
Date: Tue, 27 Jan 2009 18:20:58 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>
Subject: nfsd fixes for 2.6.29
Message-ID: <20090127232058.GC13854@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes are available in the git repository at:

  git://linux-nfs.org/~bfields/linux.git for-2.6.29

Mainly three regression fixes, but I also snuck in two minor
documentation updates.  (I can stop that if it's annoying.)

--b.

J. Bruce Fields (3):
      nfs: note that CONFIG_SUNRPC_XPRT_RDMA turns on server side support too
      nfsd: fix null dereference on error path
      nfsd: fix cred leak on every rpc

James Lentini (1):
      update port number in NFS/RDMA documentation

Jeff Layton (1):
      nfsd: only set file_lock.fl_lmops in nfsd4_lockt if a stateowner is found

 Documentation/filesystems/nfs-rdma.txt |    4 ++--
 fs/nfsd/auth.c                         |    3 +++
 fs/nfsd/nfs4state.c                    |    1 -
 net/sunrpc/Kconfig                     |    5 ++---
 4 files changed, 7 insertions(+), 6 deletions(-)
