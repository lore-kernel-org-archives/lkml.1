Return-Path: <linux-kernel-owner+w=401wt.eu-S1757903AbZCRQWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbZCRQWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 12:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbZCRQVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 12:21:41 -0400
Received: from mail.fieldses.org ([141.211.133.115]:49032 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbZCRQVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:21:39 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       Igor Zhbanov <izh1979@gmail.com>, Serge Hallyn <serue@us.ibm.com>
Subject: nfsd patches for 2.6.29
Date: Wed, 18 Mar 2009 12:21:30 -0400
Message-Id: <1237393292-14934-1-git-send-email-bfields@fieldses.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following bugfixes are also available from the for-2.6.29 git
repository at:

  git://linux-nfs.org/~bfields/linux.git for-2.6.29

The CAP_MKNOD change should really go into CAP_FS_MASK, but that will be
a user-visible change, and some more deliberation may be required to be
sure we have CAP_FS_MASK exactly right; so I prefer to go ahead with the
one obvious nfsd-specific change now.

--b.

Benny Halevy (1):
      NFSD: provide encode routine for OP_OPENATTR

J. Bruce Fields (1):
      nfsd: nfsd should drop CAP_MKNOD for non-root

 fs/nfsd/nfs4xdr.c          |    1 +
 include/linux/capability.h |    6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)
