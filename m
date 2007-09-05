Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbXIEVWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbXIEVWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 17:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756826AbXIEVWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 17:22:19 -0400
Received: from mail.fieldses.org ([66.93.2.214]:60913 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756435AbXIEVWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 17:22:17 -0400
From: "J. Bruce Fields" <bfields@citi.umich.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: nfsd patches for 2.6.23
Date: Wed,  5 Sep 2007 17:22:11 -0400
Message-Id: <1189027333981-git-send-email-bfields@citi.umich.edu>
X-Mailer: git-send-email 1.5.3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We've got two nfsd patches that fix a regression and a possible oops, so
both should probably go in before the 2.6.23 release.

Patches will follow, but they're also available from "for-linus" at:

  ssh://linux-nfs.org/~bfields/exports/linux.git for-linus

--b.

Neil Brown (2):
      knfsd: Fixed problem with NFS exporting directories which are mounted on.
      knfsd: Validate filehandle type in fsid_source

 fs/nfsd/nfsfh.c |   20 +++++++++++++++-----
 fs/nfsd/vfs.c   |    3 ++-
 2 files changed, 17 insertions(+), 6 deletions(-)
