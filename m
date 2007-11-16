Return-Path: <linux-kernel-owner+w=401wt.eu-S934082AbXKPSzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082AbXKPSzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548AbXKPSz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:55:26 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46930 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbXKPSzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:55:25 -0500
Date: Fri, 16 Nov 2007 10:50:08 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.23.7
Message-ID: <20071116185008.GM9807@kroah.com>
References: <20071116183752.GA9807@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116183752.GA9807@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.23.7 kernel.
It contains a number of bugfixes filesystem specific issus.

I'll also be replying to this message with a copy of the patch between
2.6.23.6 and 2.6.23.7

The updated 2.6.23.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.23.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.23.y.git;a=summary

thanks,

greg k-h

--------

 Makefile            |    2 +-
 fs/minix/itree_v1.c |    9 +++++++--
 fs/minix/itree_v2.c |    9 +++++++--
 fs/nfs/write.c      |   17 +++++++++++++----
 fs/ocfs2/aops.c     |   22 ++++++++++++++++++++++
 5 files changed, 50 insertions(+), 9 deletions(-)

Summary of changes from v2.6.23.6 to v2.6.23.7
==============================================

Eric Sandeen (1):
      minixfs: limit minixfs printks on corrupted dir i_size (CVE-2006-6058)

Greg Kroah-Hartman (1):
      Linux 2.6.23.7

Mark Fasheh (1):
      ocfs2: fix write() performance regression

Trond Myklebust (1):
      NFS: Fix a writeback race...

