Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbYHLUEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbYHLUEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 16:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbYHLUE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 16:04:27 -0400
Received: from mail.fieldses.org ([66.93.2.214]:41740 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbYHLUE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 16:04:27 -0400
Date: Tue, 12 Aug 2008 16:04:23 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       Neil Brown <neilb@suse.de>
Subject: nfsd-related changes for 2.6.27
Message-ID: <20080812200423.GA384@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few nfsd-related changes are ready in:

	git://linux-nfs.org/~bfields/linux.git for-2.6.27

One is a bugfix and the other two are completely trivial, so I assume
all are appropriate for 2.6.27.

--b.

Harvey Harrison (1):
      lockd: trivial sparse endian annotations

J. Bruce Fields (1):
      MAINTAINERS: mention lockd and sunrpc in nfs entries

Julia Lawall (1):
      fs/nfsd/export.c: Adjust error handling code involving auth_domain_put

 MAINTAINERS         |    4 ++--
 fs/lockd/svc4proc.c |    4 ++--
 fs/lockd/svcproc.c  |    4 ++--
 fs/nfsd/export.c    |    6 +++---
 4 files changed, 9 insertions(+), 9 deletions(-)
